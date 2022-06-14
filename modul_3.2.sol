//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

contract Lottery
{
    mapping (address => mapping (uint256 => uint256[])) ticketsList;
    mapping (uint256 => address) ticketsOwner;
    uint256 public initialTicketsSupply = 0;


    function addTickets(uint256 round, uint256 ticketsAmount) public
    {
        for(uint i = 1; i <= ticketsAmount; i++) 
        {
            ticketsList[msg.sender][round].push(initialTicketsSupply + i);
            ticketsOwner[initialTicketsSupply + i] = msg.sender;
        }
    }
}
