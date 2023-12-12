// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract SamplesCalculateAverage {

    address public owner;
    int[] private average;
    uint[] public lastUpdateTime;
    uint[] public lastUpdateBlock;

    constructor() {
        owner = msg.sender;
    }

    function calculateAverage(int _a, int _b) public {
        average.push(int((_a + _b)/2));
        lastUpdateTime.push(block.timestamp);
        lastUpdateBlock.push(block.number);
    }

    function getSamplesA() public view returns(int[] memory) {
        return average;
    }

    function getValue(uint index) public view returns(int) {
        return average[index];
    }

    function getLastValue() public view returns(int) {
        return average[average.length-1];
    }

    function getUpdatingTimeHistory() public view returns(uint[] memory) {
        return lastUpdateTime;
    }

    function getUpdatingBlockHistory() public view returns(uint[] memory) {
        return lastUpdateBlock;
    }

    function getLastUpdate() public view returns(uint, uint) {
        return (lastUpdateTime[lastUpdateTime.length-1], lastUpdateBlock[lastUpdateBlock.length-1]);
    }

}