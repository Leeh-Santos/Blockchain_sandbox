// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract Fundmenigga{
 //0x694AA1769357215DE4FAC081bf1f309aDC325306
    uint256 public minimuplata = 5e18;

    address[] public funders;

    address public owner;
    mapping (address => uint256) public ammountdonated;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable {
        require(ethtousd(msg.value) >= minimuplata, "deu ruim");
        funders.push(msg.sender);
        ammountdonated[msg.sender] = ammountdonated[msg.sender] + msg.value;
    }

    
    function withdraw() public must {
        for (uint256 i = 0; i < funders.length ; i++ ){
            address funder = funders[i];
            ammountdonated[funder] = 0;
        }
        funders = new address[](0);

        (bool ok, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(ok, "deu ruim");
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface price1 =  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price,,,) = price1.latestRoundData();
        return uint(price * 1e10);
    }

    function ethtousd(uint256 _ammount) public view returns (uint256){
        uint256 eth = getPrice();
        uint256 conversion = (eth * _ammount) / 1e18;
        return conversion;
    }

    modifier must() {
        require(msg.sender == owner, "not the owner of the contract");
        _;
    }

}   