//contracts/CarbonChain.sol
//SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CarbonChain is ERC20 {

    uint256 public creditValue;
    uint256 public initialAmount;

    struct toSell{
        uint256 amountToSell;
        address sellerAddress;
    }

    toSell[] toSellArr;

    constructor(uint256 _initialAmount, uint256 _maxLimit) ERC20("CarbonCredit", "CCT"){
        require(_initialAmount <= _maxLimit, "Max amount must be less than initial value");
        initialAmount = _initialAmount;
        //supply all the tokens to the creator of the contract
        _mint(msg.sender, _initialAmount);
        //set one credit equal to one dollar in eth
        creditValue = 32*10**18;
    }

    modifier sellReq(uint256 _sellAmount) {
        require(balanceOf(msg.sender) >= _sellAmount, "Cannot sell more than possesion");
        _;
    }

    function creditRate() public returns(uint256) {
        return ((creditValue*initialAmount)/totalSupply());
    }

    function sellCredit(uint256 _sellAmount) public sellReq(_sellAmount) returns(bool) {
        toSell memory x = toSell(_sellAmount, msg.sender);
        toSellArr.push(x);
    }

    function buyCredit() {}

    function generateCredits() {

    }

}
