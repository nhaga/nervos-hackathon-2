/* SPDX-License-Identifier: UNLICENSED */
pragma solidity ^0.8.0;

contract Utils {
    function _getMaxPrice(uint256[] memory arr) public view returns (uint256) {
        uint256 largest = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] > largest) {
                largest = arr[i];
            }
        }
        return largest;
    }

    function _getMinPrice(uint256[] memory arr) public view returns (uint256) {
        uint256 lowest = 99999999999999;

        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] < lowest) {
                lowest = arr[i];
            }
        }
        return lowest;
    }
}
