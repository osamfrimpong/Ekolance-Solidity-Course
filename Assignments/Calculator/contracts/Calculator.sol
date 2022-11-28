// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Calculator {
    function addNumbers(uint a, uint b) external pure returns (uint c) {
        c = a + b;
    }

    function subtractNumbers(uint a, uint b) external pure returns (uint c) {
        if( a >= b)
        {
             c = a - b;
        }
        else{
            c = b - a;
        }
       
    }

    function multiplyNumbers(uint a, uint b) external pure returns (uint c) {
        c = a * b;
    }

    function divideNumbers(uint a, uint b) external pure returns (uint c) {
        // require(b != 0, "Second NUmber cannot be 0");
        if (b != 0) {
            c = a / b;
        }
    }
}
