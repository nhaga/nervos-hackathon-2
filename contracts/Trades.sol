// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./oLToken.sol";
import "./oSToken.sol";
import "./interface/CollateralInterface.sol";
import "./Collateral.sol";

contract Trades is Collateral {
    event Trade(address trader, uint256 side, uint256 price, uint256 size);
    event Orderbook(Order[]);

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

    mapping(uint256 => Order) public orders;
    mapping(uint256 => uint256) public fills;
    mapping(address => uint256) public positions;

    uint256 orderCount;
    uint256 public expiry;
    uint256 public strike;
    address public owner;

    OLToken public longTokenContract;
    OSToken public shortTokenContract;

    constructor(
        uint256 _expiry,
        uint256 _strike,
        address _currencyAddress
    ) {
        strike = _strike;
        expiry = _expiry;
        currencyAddress = _currencyAddress;
        longTokenContract = new OLToken();
        shortTokenContract = new OSToken();
        owner = msg.sender;
    }

    function _is_matched(Order memory _order) private view returns (bool) {
        if (uint256(_order.side) == 1) {
            return _order.price >= _getBestAsk(); //bestAsk;
        }
        if (uint256(_order.side) == 2) {
            return _order.price <= _getBestBid(); //bestBid;
        }
        return false;
    }

    function getTrades() public view returns (Order[] memory) {
        Order[] memory aOrders = new Order[](orderCount);
        for (uint256 i = 0; i < orderCount; i++) {
            Order storage trade = orders[i];
            aOrders[i] = trade;
        }
        return aOrders;
    }

    function sort(Order[] memory data, uint256 side)
        public
        view
        returns (Order[] memory)
    {
        if (side == 1) {
            descQuickSort(data, int256(0), int256(data.length - 1));
        } else {
            ascQuickSort(data, int256(0), int256(data.length - 1));
        }
        return data;
    }

    function descQuickSort(
        Order[] memory arr,
        int256 left,
        int256 right
    ) internal view {
        int256 i = left;
        int256 j = right;
        if (i == j) return;
        uint256 pivot = arr[uint256(left + (right - left) / 2)].price;
        while (i <= j) {
            while (arr[uint256(i)].price > pivot) i++;
            while (pivot > arr[uint256(j)].price) j--;
            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (
                    arr[uint256(j)],
                    arr[uint256(i)]
                );
                i++;
                j--;
            }
        }
        if (left < j) descQuickSort(arr, left, j);
        if (i < right) descQuickSort(arr, i, right);
    }

    function ascQuickSort(
        Order[] memory arr,
        int256 left,
        int256 right
    ) internal view {
        int256 i = left;
        int256 j = right;
        if (i == j) return;
        uint256 pivot = arr[uint256(left + (right - left) / 2)].price;
        while (i <= j) {
            while (arr[uint256(i)].price < pivot) i++;
            while (pivot < arr[uint256(j)].price) j--;
            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (
                    arr[uint256(j)],
                    arr[uint256(i)]
                );
                i++;
                j--;
            }
        }
        if (left < j) ascQuickSort(arr, left, j);
        if (i < right) ascQuickSort(arr, i, right);
    }

    function getOpenSide(uint256 side) public view returns (Order[] memory) {
        uint256 resultCount;
        for (uint256 i = 0; i < orderCount; i++) {
            if (
                uint256(orders[i].side) == side && uint256(orders[i].state) == 0
            ) {
                resultCount++;
            }
        }
        uint256 j;
        Order[] memory aOrders = new Order[](resultCount);
        if (resultCount == 0) {
            return aOrders;
        }
        for (uint256 i = 0; i < orderCount + 1; i++) {
            if (
                uint256(orders[i].side) == side && uint256(orders[i].state) == 0
            ) {
                aOrders[j] = orders[i];
                j++;
            }
        }
        return sort(aOrders, side);
    }

    function getOrderbook() public view returns (Order[] memory) {
        uint256 j;
        Order[] memory aOrders = new Order[](orderCount);
        for (uint256 i = 0; i < orderCount; i++) {
            aOrders[j] = orders[i];
            j++;
        }
        return aOrders;
    }

    function enterOrder(
        uint256 side,
        uint256 price,
        uint256 size
    ) public {
        require(uint128(size) == size);
        require(uint128(price) == price);
        require(side == 1 || side == 2);
        require(price > 0);
        require(size > 0);

        Order memory order;
        order.tradeId = orderCount;
        order.side = OrderSide(side);
        order.price = price;
        order.size = size;
        order.trader = msg.sender;
        order.timestamp = block.timestamp;
        order.state = OrderState.OPEN;

        if (_is_matched(order)) {
            executeTrade(order);
        } else {
            addToOrderbook(order);
        }

        emit Trade(msg.sender, side, price, size);
        emit Orderbook(getOrderbook());
    }

    function insertOrder(Order memory _order) internal {
        orders[orderCount] = _order;
        orderCount++;
    }

    function addToOrderbook(Order memory _order) internal {
        orders[orderCount] = _order;
        orderCount++;
        if (uint256(_order.side) == 1) {
            uint256 amount = _order.size * _order.price;
            depositEscrowFrom(_order.trader, amount);
        }
        if (uint256(_order.side) == 2) {
            uint256 amount = (_order.size * _order.price) +
                (_order.size * _order.price) /
                2;
            depositCurrencyFrom(_order.trader, amount);
        }
    }

    function fillOrder(
        address seller,
        address buyer,
        uint256 size,
        uint256 price,
        bool fromEscrow
    ) internal {
        uint256 amount = price * size;
        longTokenContract.mint(buyer, size);
        shortTokenContract.mint(seller, size);
        if (fromEscrow) {
            require(escrowBalanceOf[buyer] >= amount);
            transferEscrowTo(buyer, seller, amount);
        } else {
            transferTo(buyer, seller, amount);
        }
        positions[seller] += size;
        if (positions[buyer] >= size) {
            positions[buyer] -= size;
        }
    }

    function executeTrade(Order memory _order) public payable {
        require(msg.sender == _order.trader);
        // BUY
        uint256 counter;
        if (uint256(_order.side) == 1) {
            Order[] memory availableOrders = getOpenSide(2);
            uint256 amountToFill = _order.size;
            Order memory askOrder;
            while (amountToFill > 0) {
                askOrder = availableOrders[counter];
                if (askOrder.size >= _order.size) {
                    fillOrder(
                        askOrder.trader,
                        msg.sender,
                        _order.size,
                        askOrder.price,
                        false
                    );
                    fills[askOrder.tradeId] = _order.tradeId;
                    _order.price = askOrder.price;
                    orders[askOrder.tradeId].state = OrderState.FILLED;
                    orders[askOrder.tradeId].size = _order.size;

                    // Remainder for a Partial Fill
                    if (askOrder.size > _order.size) {
                        insertOrder(
                            Order(
                                orderCount + 1,
                                OrderSide.SELL,
                                askOrder.price,
                                askOrder.size - _order.size,
                                askOrder.timestamp,
                                askOrder.trader,
                                OrderState.OPEN
                            )
                        );
                    }
                    _order.state = OrderState.FILLED;
                    insertOrder(_order);
                    amountToFill -= _order.size;
                } else {
                    // Order.size > bestAsk.size
                    fillOrder(
                        askOrder.trader,
                        msg.sender,
                        askOrder.size,
                        askOrder.price,
                        false
                    );
                    fills[askOrder.tradeId] = _order.tradeId;
                    orders[askOrder.tradeId].state = OrderState.FILLED;

                    // Split Buy Order
                    insertOrder(
                        Order(
                            orderCount,
                            OrderSide.BUY,
                            askOrder.price,
                            askOrder.size,
                            _order.timestamp,
                            _order.trader,
                            OrderState.FILLED
                        )
                    );
                    if (counter == availableOrders.length - 1) {
                        break;
                    }
                    amountToFill -= askOrder.size;
                    counter++;
                }
            }
            if (amountToFill > 0) {
                insertOrder(
                    Order(
                        orderCount,
                        OrderSide.BUY,
                        _order.price,
                        amountToFill - askOrder.size,
                        _order.timestamp,
                        _order.trader,
                        OrderState.OPEN
                    )
                );
            }
        }

        // SELL
        if (uint256(_order.side) == 2) {
            Order[] memory availableOrders = getOpenSide(1);
            uint256 amountToFill = _order.size;
            depositCurrency(
                (_order.size * _order.price) + (_order.size * _order.price) / 2
            );
            Order memory bidOrder;
            while (amountToFill > 0) {
                bidOrder = availableOrders[counter];
                if (bidOrder.size >= _order.size) {
                    fillOrder(
                        msg.sender,
                        bidOrder.trader,
                        _order.size,
                        bidOrder.price,
                        true
                    );
                    fills[_order.tradeId] = bidOrder.tradeId;
                    _order.price = bidOrder.price;
                    orders[bidOrder.tradeId].state = OrderState.FILLED;
                    orders[bidOrder.tradeId].size = _order.size;

                    // Remainder for a Partial Fill
                    if (bidOrder.size > _order.size) {
                        insertOrder(
                            Order(
                                orderCount,
                                OrderSide.BUY,
                                bidOrder.price,
                                bidOrder.size - _order.size,
                                bidOrder.timestamp,
                                bidOrder.trader,
                                OrderState.OPEN
                            )
                        );
                    }
                    _order.state = OrderState.FILLED;
                    insertOrder(_order);
                    amountToFill -= _order.size;
                } else {
                    // Order.size > bestBid.size
                    fillOrder(
                        msg.sender,
                        bidOrder.trader,
                        bidOrder.size,
                        bidOrder.price,
                        true
                    );

                    fills[_order.tradeId] = bidOrder.tradeId;
                    orders[bidOrder.tradeId].state = OrderState.FILLED;

                    // Split SELL Order
                    insertOrder(
                        Order(
                            orderCount,
                            OrderSide.SELL,
                            bidOrder.price,
                            bidOrder.size,
                            _order.timestamp,
                            _order.trader,
                            OrderState.FILLED
                        )
                    );
                    if (counter == availableOrders.length - 1) {
                        break;
                    }
                    amountToFill -= bidOrder.size;
                    counter++;
                }
            }
            if (amountToFill > 0) {
                insertOrder(
                    Order(
                        orderCount,
                        OrderSide.SELL,
                        _order.price,
                        amountToFill - bidOrder.size,
                        _order.timestamp,
                        _order.trader,
                        OrderState.OPEN
                    )
                );
            }
        }
    }

    function cancelOrder(uint256 orderId) public {
        require(msg.sender == orders[orderId].trader);
        orders[orderId].state = OrderState.CANCELLED;
        if (uint256(orders[orderId].side) == 1) {
            uint256 amount = orders[orderId].size * orders[orderId].price;
            withdrawEscrowFrom(orders[orderId].trader, amount);
        }
        if (uint256(orders[orderId].side) == 2) {
            uint256 amount = (orders[orderId].size * orders[orderId].price) +
                (orders[orderId].size * orders[orderId].price) /
                2;
            withdrawCurrencyFrom(orders[orderId].trader, amount);
        }

        emit Orderbook(getOrderbook());
    }

    function _getBestBid() public view returns (uint256) {
        Order[] memory arr = getOpenSide(1);
        uint256 largest = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i].price > largest) {
                largest = arr[i].price;
            }
        }
        return largest;
    }

    function _getBestAsk() public view returns (uint256) {
        Order[] memory arr = getOpenSide(2);
        uint256 lowest = 2**256 - 1;

        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i].price < lowest) {
                lowest = arr[i].price;
            }
        }
        return lowest;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function getTradersForLiquidation(uint256 price)
        public
        view
        returns (MtM[] memory)
    {
        // FILLED ORDERS
        uint256 resultCount;
        for (uint256 i = 0; i < orderCount; i++) {
            if (uint256(orders[i].state) == 1 && uint256(orders[i].side) == 2) {
                resultCount++;
            }
        }
        uint256 j;
        Order[] memory traderShortPositions = new Order[](resultCount);
        for (uint256 i = 0; i < orderCount; i++) {
            if (uint256(orders[i].state) == 1 && uint256(orders[i].side) == 2) {
                traderShortPositions[j] = orders[i];
                j++;
            }
        }

        uint256 bestBid = _getBestBid();
        MtM[] memory shortPositionsMtM = new MtM[](traderShortPositions.length);

        for (uint256 i = 0; i < traderShortPositions.length; i++) {
            shortPositionsMtM[i] = MtM(
                traderShortPositions[i].trader,
                positions[traderShortPositions[i].trader],
                max(bestBid, price - strike) * traderShortPositions[i].size,
                currencyBalanceOf[traderShortPositions[i].trader]
            );
        }

        return shortPositionsMtM;
    }

    function liquidatePosition(uint256 tradeId, uint256 price) public {
        Order memory shortTrade = orders[tradeId];
        Order memory longTrade = orders[fills[tradeId]];
        require(uint256(shortTrade.state) == 1);
        uint256 bestBid = _getBestBid();
        uint256 settlement = max(bestBid, price - strike) * shortTrade.size;

        // Send Settlement to Buyer
        uint256 longTraderAmount = settlement +
            settlement /
            10 +
            settlement /
            20;
        transferCurrencyTo(
            shortTrade.trader,
            longTrade.trader,
            longTraderAmount
        );

        // Send fee to liquidator
        uint256 liquidatorAmount = settlement / 20;
        transferCurrencyTo(shortTrade.trader, msg.sender, liquidatorAmount);

        // Burn OLTokens
        longTokenContract.burn(longTrade.size, longTrade.trader);

        // Burn OSTokens
        shortTokenContract.burn(shortTrade.size, shortTrade.trader);
        delete fills[tradeId];
    }

    function settlePositions(uint256 price)
        public
        returns (uint256 resultCount)
    {
        for (uint256 i = 0; i < orderCount; i++) {
            uint256 tradeId = orders[i].tradeId;
            if (fills[tradeId] > 0) {
                liquidatePosition(tradeId, price);
                resultCount++;
            }
        }
    }
}
