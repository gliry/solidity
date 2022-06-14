//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

contract BonusPoints
{
    mapping (address => uint256) private allBalance;
    mapping (address => uint256) private spendBallance;


    function getAllBalance(address user) external view returns(uint256)
    {
        return allBalance[user];
    }

    function getSpendBalance(address user) external view returns(uint256)
    {
        return spendBallance[user];
    }
}