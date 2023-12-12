// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract SamplesStorage {

    address public owner;
    int[] private a;
    int[] private b;
    uint[] public lastUpdateTime;
    uint[] public lastUpdateBlock;

    constructor() {
        owner = msg.sender;
    }

    function storeSamples(int _a, int _b) public {
        a.push(_a);
        b.push(_b);
        lastUpdateTime.push(block.timestamp);
        lastUpdateBlock.push(block.number);
    }

    function getSamplesA() public view returns(int[] memory) {
        return a;
    }

    function getLastValueA() public view returns(int) {
        return a[a.length-1];
    }

    function getLastValueB() public view returns(int) {
        return b[b.length-1];
    }

    function getValueA(uint index) public view returns(int) {
        return a[index];
    }

    function getValueB(uint index) public view returns(int) {
        return b[index];
    }

    function getSamplesB() public view returns(int[] memory) {
        return b;
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