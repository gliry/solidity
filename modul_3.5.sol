//SPDX-License-Identifier: MIT
pragma solidity 0.8.14.0;

import  "./modul_2.6.sol";

contract Lottery is BonusPoints
{
    mapping(uint256 => uint256[]) public lotteries;  // Номер лотереи - билеты
    mapping(address => mapping (uint256 => uint256[])) public ticketsList; // Участник - номер лотереи - билеты
    mapping(uint256 => address) public winners; // номер лотереи - победитель (участник)
    mapping(uint256 => uint256) public winnerTickets; // номер лотереи - победитель (билет)
    mapping(uint256 => address) public ticketsOwner; // номер билета - участник
    mapping(uint256 => uint256) public ticketPrices; // номер лотереи - цена
    uint256 public currentLot = 0; // номер текущей лотереи
    uint256 public currentTicket = 0;
    uint256 public startTime = 0; // время начала лотереи


    constructor(
        uint256 _initialAmount, 
        string memory _tokenName, 
        uint8 _decimalUnits, 
        string  memory _tokenSymbol, 
        address _owner
        ) BonusPoints(_initialAmount, _tokenName, _decimalUnits,  _tokenSymbol, _owner) {}

    modifier checkDate 
    {
        require(block.timestamp >= startTime + 1 * 30 days, "Month has not passed");
        _;    
    }

    function createLottery(uint256 price) external onlyOwner
    {
        currentTicket = 0;
        startTime = block.timestamp;
        ticketPrices[currentLot] = price;
    }

    function draw() external onlyOwner checkDate
    {
        uint256 index = randomNumber() % lotteries[currentLot].length;
        winners[currentLot] = ticketsOwner[lotteries[currentLot][index]];
        winnerTickets[currentLot] = lotteries[currentLot][index];
        currentLot += 1;
    }
    
    // Alram, not safe random!
    function randomNumber() private view returns (uint) 
    {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function getPrizePool(uint256 lotteryNumber) public view returns (uint256)
    {
        return lotteries[lotteryNumber].length * ticketPrices[lotteryNumber] -
                (ticketPrices[lotteryNumber] / 10);
    }

    function getTicketPrice(uint256 lottery) external view returns (uint256)
    {
        return ticketPrices[lottery];
    }

    function buyTicket() external
    {
        spendPoints(ticketPrices[currentLot]);
        ticketsList[msg.sender][currentLot].push(currentTicket);
        lotteries[currentLot].push(currentTicket);
        ticketsOwner[currentTicket] = msg.sender;
        currentTicket += 1;
    }

    function myTickets() external view returns (uint256[] memory)
    {
        return ticketsList[msg.sender][currentLot];
    }

    function checkTicket(uint256 ticket) public view returns (bool)
    {
        for (uint256 i = 0; i < currentLot; i++)
        {
            if(winnerTickets[i] == ticket && winners[i] == msg.sender)
            {
                return true;
            }
        }
        return false;
    }

    function getPrize() public
    {
        for (uint256 i = 0; i < currentLot; i++)
        {
            if (winners[i] == msg.sender)
            {
                balances[owner] -= getPrizePool(i);
                balances[msg.sender] += getPrizePool(i);
                winners[i] = owner;
                emit changeBalance(msg.sender, balances[msg.sender]);
            }
        }
    }
}

