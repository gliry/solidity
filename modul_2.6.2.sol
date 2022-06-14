//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

import  "./modul_2.6.sol";

contract SpecialPoints is BonusPoints
{
    mapping (address => uint8) public userType;
    // 0 - Common, 1 - Premium, 2 - VIP

    constructor(
        uint256 _initialAmount, 
        string memory _tokenName, 
        uint8 _decimalUnits, 
        string  memory _tokenSymbol, 
        address _owner
        ) BonusPoints(_initialAmount, _tokenName, _decimalUnits,  _tokenSymbol, _owner) {}

    event userTypeChanged(
        address user, 
        uint8 newType
        );

    function setUserType(address user, uint8 newType) public onlyOwner
    {
        userType[user] = newType;
        emit userTypeChanged(user, newType);
    }

    function getPoints(address user, uint256 points) external override onlyOwner
    {
        if (userType[user] == 1)
        {
            points *= 2;
        }
        else if (userType[user] == 2)
        {
            points *= 5;
        }
        balances[owner] -= points;
        balances[user] += points;
        emit changeBalance(user, balances[user]); 
    }
}