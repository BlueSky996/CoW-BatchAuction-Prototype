// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OrderBook.sol";
import "./MatchingEngine.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


contract BatchAuction {
    using SafeERC20 for IERC20;

    OrderBook public orderBook;
    MatchingEngine public matchingEngine;

    event BatchExecuted(uint256 numOrders);

    constructor(address _orderBook, address _matchingEngine){
        orderBook = OrderBook(_orderBook);
        matchingEngine = MatchingEngine(_matchingEngine);
    }


    // Simple batch Execution
    function executeBatch() external {

        uint256 matched = matchingEngine.matchOrders();
        require(matched > 0, "No matches");

        uint256 count = orderBook.getOrdersCount();
        require(count > 0, "No Orders");

        for(uint256 i = 0; i < count; i++){
            // Read Order
            (address user, address tokenIn, uint256 amountIn) = orderBook.orders(i);

            IERC20(tokenIn).safeTransferFrom(
                user,
                address(this),
                amountIn
            );
        }

        emit BatchExecuted(count);
    }

}