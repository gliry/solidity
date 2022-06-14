//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

contract currentLottery
{
    uint256 public startTime;
    uint256 public lottery_duration;

    constructor(uint256 _lottery_duration)
    {
        startTime = block.timestamp;
        lottery_duration = _lottery_duration;
    }

    modifier checkPay()
    {
        require(msg.value >= 1 ether, "Insufficient funds");
        _;
    }

    modifier checkTime()
    {
        require(block.timestamp <= currentLottery.startTime + lottery_duration, "The lottery has already ended");
        _;
    }
   
}