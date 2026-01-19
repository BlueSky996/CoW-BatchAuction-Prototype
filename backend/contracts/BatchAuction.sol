// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OrderBook.sol";
import "./MatchingEngine.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
* @title BatchAuction
* @dev Educational implementation of a CoW-style batch auction.
 *      Collects matched orders from MatchingEngine, transfers tokens in,
 *      and computes a uniform clearing price. Protected against reentrancy.
 */



contract BatchAuction is ReentrancyGuard {
    using SafeERC20 for IERC20;

    // References to other protocol components
    OrderBook public orderBook;
    MatchingEngine public matchingEngine;

    // events for off-chain monitoring
    event BatchExecuted(uint256 numOrders);
    event ClearingPrice(uint256 price);


    /**
    * @dev Initializes contract with deployed OrderBook and matchingEngine addresss.
    * @param _orderBook Address of deployed OrderBook contract.
    * @param  _matchingEngine Address of deployed MatchingEngine contract.
     */

    constructor(address _orderBook, address _matchingEngine){
        orderBook = OrderBook(_orderBook);
        matchingEngine = MatchingEngine(_matchingEngine);
    }


   /**
   * @dev compute a simples uniform clearing price.
   *        currently, it calculate average amountIn of filled orders.
   * @return price the computed clearing price
   */

    function computClearingPrice() internal view returns(uint256 price) {
        uint256 count = orderBook.getOrdersCount();
        uint256 total;

        for (uint256 i = 0; i < count; i++){
            (
                , , ,
                uint256 amountIn,
                ,
                bool filled
            ) = orderBook.orders(i);

            if (filled) {
                total += amountIn;
            }

        }

        require(total > 0, "No Filled orders");
        price = total / count;

    }


    /**
    * @dev execute a batch of matched orders.
    *      transfers tokenIn from users to this contract
    *      compute uniform clearing price and emit relevent events.
     */

    function executeBatch() external nonReentrant {

        // match order using matching engine
        uint256 matched = matchingEngine.matchOrders();
        require(matched > 0, "No matches");

        uint256 count = orderBook.getOrdersCount();
        require(count > 0, "No Orders");

        // transfer tokenIn from each user for all orders

        for(uint256 i = 0; i < count; i++){
            // Read Order
            (address user, address tokenIn, , uint256 amountIn, ,) = orderBook.orders(i);

            IERC20(tokenIn).safeTransferFrom(
                user,
                address(this),
                amountIn
            );
        }

        uint256 clearingPrice = computClearingPrice();
        emit ClearingPrice(clearingPrice);
        emit BatchExecuted(count);
    }


}