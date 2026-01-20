// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./OrderBook.sol";

contract MatchingEngine {
    OrderBook public orderBook;

    event OrdersMatched(uint256 buyOrderId, uint256 sellOrderId);

    constructor(address _orderBook){
        orderBook = OrderBook(_orderBook);
    }

    function matchOrders() external returns (uint256 matchedCount){
        uint256 count = orderBook.getOrdersCount();

        for (uint256 i = 0; i < count; i++) {
            (
                ,
                address buyTokenIn,
                address buyTokenOut,
                ,
                OrderBook.Side buySide,
                bool buyFilled
            ) = orderBook.orders(i);

            if (buySide != OrderBook.Side.Buy || buyFilled) continue;

            for (uint256 j = i + 1; j < count; j++) {
                (
                    ,
                    address sellTokenIn,
                    address sellTokenOut,
                    ,
                    OrderBook.Side sellSide,
                    bool sellFilled
                ) = orderBook.orders(j);

                if (
                    sellSide == OrderBook.Side.Sell && !sellFilled && 
                    buyTokenIn == sellTokenOut &&
                    buyTokenOut == sellTokenIn
                ) {
                    orderBook.markFilled(i);
                    orderBook.markFilled(j);

                    emit OrdersMatched(i, j);
                    matchedCount++;
                    break;
                }
            }
        }
    }

}