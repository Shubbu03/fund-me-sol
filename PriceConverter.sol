// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

function getPrice() internal view returns(uint256){
    //address for sepolia ethereum - 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //address for zksync - 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF

    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
     (, int256 price, , , ) = priceFeed.latestRoundData();
     // price of eth in terms of usd
     return uint256(price * 1e10);
}

function getConversionRate(uint256 ethAmount) internal view returns(uint256){
    // msg.value.getConversionRate();
    
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

    return ethAmountInUsd;
}

function getVersion() internal view returns(uint256){
    return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
}
}