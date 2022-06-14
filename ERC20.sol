// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

import  "./IERC20.sol";

contract ERC20 is IERC20{
    
    uint256 constant private MAX_UINT256 = type(uint).max;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    uint public override totalSupply;
    string public override name;
    uint public override decimals;
    string public override symbol;
    address public owner;


    constructor(uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string  memory _tokenSymbol, address _owner) {
        owner = _owner;
        balances[_owner] = _initialAmount;               // Give the creator all initial tokens
        totalSupply = _initialAmount;                        // Update total supply
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
    }


    function transfer(address _to, uint256 _value) public override returns (bool success) {
        _beforeAmount();
        require(balances[msg.sender] >= _value, "token balance is lower than the value requested");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        _afterAmount();

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        _beforeAmount();
        uint256 _allowance = allowances[_from][msg.sender];
        require(balances[_from] >= _value && _allowance >= _value, "token balance or allowance is lower than amount requested");
        balances[_to] += _value;
        balances[_from] -= _value;
        if (_allowance < MAX_UINT256) {
            allowances[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        _afterAmount();
        return true;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }

    // for extensions

    function _beforeAmount() internal virtual{ 
        // overrided code is here
    }

    function _afterAmount() internal virtual{
        // overrided code is here
    }


}