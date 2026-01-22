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

        for (uint256 i; i < count; ) {
            OrderBook.Order memory buy = orderBook.getOrder(i);

            if (buy.side != OrderBook.Side.Buy || buy.filled) {
                unchecked { ++i; }
                continue;
            }

            for (uint256 j = i + 1; j < count; ) {
                OrderBook.Order memory sell = orderBook.getOrder(j);

                if (
                    sell.side == OrderBook.Side.Sell && !sell.filled && 
                    buy.tokenIn == sell.tokenOut &&
                    buy.tokenOut == sell.tokenIn
                ) {
                    orderBook.markFilled(i);
                    orderBook.markFilled(j);

                    emit OrdersMatched(i, j);
                    matchedCount++;
                    break;
                }


                unchecked {
                    ++j;
                }

            }
            unchecked {
                ++i;
            }
        }
    }

}