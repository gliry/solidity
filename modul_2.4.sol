//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;
import "./modul_1.sol";

contract SpecialPoints is BonusPoints
{
    mapping (address => uint8) private status;

    function addPremium(int256 amount, int256 difference) internal pure returns (int256)
    {
        return amount + 2 * difference;
    }

    function addVip(int256 amount, int256 difference) internal pure returns (int256)
    {
        return amount + 5 * difference;
    }
}