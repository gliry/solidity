//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

contract Lottery
{
    mapping (address => mapping (uint256 => uint256[])) ticketsList;
    mapping (uint256 => address) ticketsOwner;

    
}