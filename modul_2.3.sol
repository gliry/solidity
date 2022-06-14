//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

contract Owner
{
    address public owner;

    constructor()
    {
        owner = msg.sender;
    }
    
    function getOwner() public view returns(address)
    {
        return owner;
    }
}