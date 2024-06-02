// SPDX-License-Identifier: GPL-3.0-or-later

// sepolia: 0xDa2e92f253d7E6e4fe40756ed8C57e7fE6607326

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract CC is ERC20 {
    using Address for address;

    uint256 public creditValue;
    uint256 public initialAmount;
    AggregatorV3Interface internal priceFeed;

    struct toSell {
        uint256 amountToSell;
        address sellerAddress;
    }

    toSell[] toSellArr;

    constructor(
        uint256 _initialAmount,
        uint256 _maxLimit,
        address _priceFeed
    ) ERC20("CarbonCredit", "CCT") {
        require(
            _initialAmount <= _maxLimit,
            "Max amount must be less than initial value"
        );
        initialAmount = _initialAmount;
        // Supply all the tokens to the creator of the contract
        _mint(msg.sender, _initialAmount * (10 ** decimals()));
        // Set one credit equal to one dollar in eth
        creditValue = 32 * (10 ** decimals());
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    modifier sellReq(uint256 _sellAmount) {
        require(
            balanceOf(msg.sender) >= _sellAmount,
            "Cannot sell more than possession"
        );
        _;
    }

    modifier buyReq(uint256 _amount, address _buyFrom) {
        require(msg.value >= _amount * creditRate(), "More amount required");
        bool mmt = false;
        for (uint i = 0; i < toSellArr.length; i++) {
            if (toSellArr[i].sellerAddress == _buyFrom) {
                mmt = true;
            }
        }
        require(mmt, "There must be the specified seller");
        _;
    }

    modifier generateCreditsMod(string memory _textHash, address _awardee) {
        _;
    }

    function creditRate() public view returns (uint256) {
        return ((creditValue * initialAmount) / totalSupply());
    }

    function getLatestPrice() public view returns (int) {
        (
            ,
            /* uint80 roundID */ int price /* uint startedAt */ /* uint timeStamp */ /* uint80 answeredInRound */,
            ,
            ,

        ) = priceFeed.latestRoundData();
        return price;
    }

    function sellCredit(
        uint256 _sellAmount
    ) public sellReq(_sellAmount) returns (bool) {
        toSell memory x = toSell(_sellAmount, msg.sender);
        toSellArr.push(x);
        return true;
    }

    function buyCredit(
        uint256 _amount,
        address _buyFrom
    ) public payable buyReq(_amount, _buyFrom) returns (bool) {
        // $ to seller
        (bool success, ) = _buyFrom.call{value: _amount * creditRate()}("");

        // CCT to buyer (90%)
        ERC20 CCT = ERC20(address(this));

        CCT.approve(address(this), _amount);

        CCT.transferFrom(_buyFrom, msg.sender, (_amount * 9) / 10);

        _burn(msg.sender, _amount / 10);

        return success;
    }

    function generateCredits(
        string memory _textHash,
        address _awardee
    ) public generateCreditsMod(_textHash, _awardee) returns (bool) {
        _mint(_awardee, totalSupply() / 100);
        return true;
    }

    // Moonbeam's batchAll functionality
    // function batchAll(bytes[] memory calls) public {
    //     for (uint i = 0; i < calls.length; i++) {
    //         address(this).functionCall(calls[i], "Batch call failed");
    //     }
    // }
}
