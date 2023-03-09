// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    // Accept payment

    mapping(address => uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public{
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }
    
    // collect eth
    function fund() public payable{
        // 0.5$
        uint256 minimumUSD = 0.5*10**18;
        // 1gewi < 0.5$
        require(getConversionRate(msg.value) >= minimumUSD, "Not enough ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256){
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000); // put in gwei
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        return (ethPrice * ethAmount) / 1000000000000000000;
    }

    function getEntranceFee() public view returns(uint256){
        uint256 minimumUSD = 50 * 10**18;
        uint256 ethPrice = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision)/ethPrice;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner); //verify that the one withdraws the eth is the owner  
        _;
    }
    // pull the collected eth
    function withdraw() payable onlyOwner public{
        //address(this)= address of the current contract
        payable(msg.sender).transfer(address(this).balance);
        for(uint256 funderIndex=0; funderIndex<funders.length; funderIndex++){
            addressToAmountFunded[address(funders[funderIndex])] = 0;
        }
        funders = new address[](0); //reset funders array
    }
}