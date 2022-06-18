//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

contract Documents
{
    mapping(uint8 => bytes32) certificates;

    function hash(string memory str) public pure returns(bytes32)
    {
        return keccak256(abi.encodePacked(str));
    }

    function addCertificate(uint8 passport, bytes32 certHash) external
    {
        certificates[passport] = certHash;
    }

    
}