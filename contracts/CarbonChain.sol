//contracts/CarbonChain.sol
//SPDX-Licensce-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CarbonChain is ERC20 {
    
    constructor (uint256 _initialSupply, uint256 _upperLimit) ERC20("CarbonCredits", "CCT") {

        require(_initialSupply<=_upperLimit, "Upper limit cannot be more than total supply");
        //supply all the initial tokens to the deployer
        _mint(msg.sender, _initialSupply);
    }

    // mapping(address => uint256) public creditAccountsBalances;

    mapping(address => uint256) private toSell;

    modifier sellMod(uint256 _amount) {
        require(_amount <= balanceOf(msg.sender), "cannot sell more than possesion");
        _;
    }

    function sellCredits(uint256 _amount) public sellMod(_amount) returns(bool) {
        // creditAccountsBalances[msg.sender] -= _amount;
        toSell[msg.sender] += _amount;
        return true;
    }
}
