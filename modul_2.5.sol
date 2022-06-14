//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

contract BonusPoints
{
    mapping (address => int256) public storage _balances;
    address private owner;

    constructor()
    {
        owner = msg.sender;
    }
    // for use only by the administration of the shopping center
    modifier onlyOwner() 
    {
        require(msg.sender == owner, "Only owner may do this!");
        _;
    }

    event changeBalance(
        address user, 
        int256 new_balance
        );
        
    // May be done with one function that uses address and difference,
    // but consider it as an attempt to follow the task
    function getBalance(address user, int256 difference) external onlyOwner
    {
        if (difference >= 0)
        {
            _balances[user] = add(_balances[user], difference);
        }
        else if (difference < 0)
        {
            _balances[user] = substract(_balances[user], difference);
        }
        emit changeBalance(user, _balances[user]);
    }

    function add(int256 amount, int256 difference) internal pure returns (int256)
    {
        return amount + difference;
    }

    function substract(int256 amount, int256 difference) internal pure returns (int256)
    {
        require(amount >= -difference, "Isufficient funds");
        return amount + difference;
    }
}