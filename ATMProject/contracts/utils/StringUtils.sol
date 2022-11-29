// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;


library StringUtils{

function getPinLength(string calldata pin) public pure returns(uint256){
    uint256 length;
    uint256 i = 0;
    uint256 byteLength = bytes(pin).length;
    for(i = 0; i < byteLength; length++){
        bytes1 b = bytes(pin)[i];

        if (b < 0x80){
            i+=1;
        }
        else if (b < 0xE0){
            i += 2;
        }

    }

    return length;
}

function substring(string memory str, uint startIndex, uint endIndex) public pure returns (string memory ) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(endIndex-startIndex);
    for(uint i = startIndex; i < endIndex; i++) {
        result[i-startIndex] = strBytes[i];
    }
    return string(result);
}

}