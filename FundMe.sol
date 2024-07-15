// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{
//get funds from user
//withdraw funds
//set minimum funding value in usd

using PriceConverter for uint256; //library

uint256 public constant minUSD = 5e18;

address[] public funders;
mapping(address funder => uint256 amountSend) public funderToAmountSent;

address public immutable owner;

constructor(){
    owner = msg.sender;

}


function fund() public payable {
    
    require(msg.value.getConversionRate() >= minUSD,"Please send atleast minimum value");
    funders.push(msg.sender);
    funderToAmountSent[msg.sender] += msg.value;
    //Revert - undo any actions that have been done,and send remaining gas back
}

function withdraw() public onlyOwner{
    for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
        address funder = funders[funderIndex];
        funderToAmountSent[funder] = 0;
    }
    funders = new address[](0);

    //transfer
    // payable(msg.sender).transfer(address(this).balance);

    //send
    // bool success = payable(msg.sender).send(address(this).balance);
    // require(success,"send failed");

    //call
    (bool callSuccess , ) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess,"failed");
}

modifier onlyOwner() {
    require(msg.sender == owner,"Sender is not owner");
    _; 
}

receive() external payable { 
    fund();
}

fallback() external payable {
    fund();
 }


}