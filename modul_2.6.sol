//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

import  "./ERC20.sol";

contract BonusPoints is ERC20
{
    constructor(
        uint256 _initialAmount, 
        string memory _tokenName, 
        uint8 _decimalUnits, 
        string  memory _tokenSymbol, 
        address _owner
        ) ERC20(_initialAmount, _tokenName, _decimalUnits,  _tokenSymbol, _owner) {}

    mapping (address => uint256) public spendBallance;

    // for use only by the administration of the shopping center
    modifier onlyOwner() 
    {
        require(msg.sender == owner, "Only owner may do this!");
        _;
    }

    event changeBalance(
        address user, 
        uint256 new_balance
        );    

    function spendPoints(uint256 points) external  
    {
        require(balances[msg.sender] >= points, "Isufficient funds");
        balances[msg.sender] -= points;
        balances[owner] += points;
        spendBallance[msg.sender] += points;
        emit changeBalance(msg.sender, balances[msg.sender]);
    }

    function getPoints(address user, uint256 points) external virtual onlyOwner
    {
        balances[owner] -= points;
        balances[user] += points;
        emit changeBalance(user, balances[user]);
    }

    function increaseTotalSupply(uint newTokensAmount) public  onlyOwner
     {
        totalSupply += newTokensAmount;
        balances[owner] += newTokensAmount;
    }
}