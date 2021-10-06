// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../oLToken.sol";
import "../oSToken.sol";

interface TradesInterface {
    enum OrderSide {
        NONE,
        BUY,
        SELL
    }
    enum OrderState {
        OPEN,
        FILLED,
        CANCELLED
    }

    struct Order {
        uint256 tradeId;
        OrderSide side;
        uint256 price;
        uint256 size;
        uint256 timestamp;
        address trader;
        OrderState state;
    }

    struct MtM {
        address trader;
        uint256 position;
        uint256 marketValue;
        uint256 collateral;
    }

    function enterOrder(
        uint256 side,
        uint256 price,
        uint256 size
    ) external;

    function getBalanceOf(address _account) external view returns (uint256);

    function getCurrencyBalanceOf(address _account)
        external
        view
        returns (uint256);

    function getEscrowBalanceOf(address _account)
        external
        view
        returns (uint256);

    function deposit(uint256 amount) external payable;

    function withdraw(uint256 amount) external;

    function depositCurrency(uint256 amount) external payable;

    function withdrawCurrency(uint256 amount) external payable;

    function depositCurrencyFrom(address _from, uint256 amount)
        external
        payable;

    function getOrderbook() external view returns (Order[] memory);

    function getTrades() external view returns (Order[] memory);

    function cancelOrder(uint256 orderId) external;

    function getTradersForLiquidation(uint256 price)
        external
        view
        returns (MtM[] memory);
}
