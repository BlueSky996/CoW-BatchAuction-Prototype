// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OrderBook {
    enum Side {
        Buy,
        Sell
    }

    struct Order {
        address user;
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        Side side;
        bool filled;
    }

    Order[] public orders;

    event OrderPlaced(
        uint256 indexed orderId,
        address indexed user,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        Side side
    );

    constructor() {
        matcher = msg.sender;
    }

    modifier onlyMatcher() {
        require(msg.sender == matcher, "Not matcher");
        _;
    }

    function placeOrder( address tokenIn, address tokenOut, uint256 amountIn, Side side) external {
        orders.push(
            Order({
                user: msg.sender,
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                amountIn: amountIn,
                side: side,
                filled: false
            })
        );

    emit OrderPlaced(
        orders.length - 1,
        msg.sender,
        tokenIn,
        tokenOut,
        amountIn,
        side
    );
    }

    function getOrdersCount() external view returns (uint256) {
        return orders.length;
    }

    function markFilled(uint256 orderId) external onlyMatcher {
        require(!orders[orderId].filled, "Already Filled");
        orders[orderId].filled = true;
    }

    
}