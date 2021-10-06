// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Liquidator.sol";
import "./Trades.sol";
import "./lib/Dateutils.sol";

contract Asset is DateUtils {
    Trades public optionContract;
    address public underlyingAddress;
    address public currencyAddress;
    address public activeOptionAddress;
    address public owner;

    mapping(uint256 => address) public optionContracts;

    uint256 private constant MAX_EXPIRY = 11865398400;

    constructor(address _underlyingAddress, address _currencyAddress) public {
        underlyingAddress = _underlyingAddress;
        currencyAddress = _currencyAddress;
        owner = msg.sender;
    }

    function addOption(
        uint256 year,
        uint256 month,
        uint256 day,
        uint256 _strike
    ) public {
        uint256 expiry = timestampFromDate(year, month, day);
        optionContract = new Trades(expiry, _strike, currencyAddress);
        activeOptionAddress = address(optionContract);
        optionContracts[expiry] = activeOptionAddress;
    }
}
