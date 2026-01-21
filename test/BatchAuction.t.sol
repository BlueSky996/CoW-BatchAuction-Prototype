// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../backend/contracts/BatchAuction.sol";
import "../backend/contracts/OrderBook.sol";
import "../backend/contracts/MatchingEngine.sol";
import "../backend/contracts/ERC20Mock.sol";


contract BatchAuctionTest is Test {

    OrderBook orderBook;
    MatchingEngine matchingEngine;
    BatchAuction batchAuction;

    ERC20Mock tokenA;
    ERC20Mock tokenB;

    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        // Deploy Erc20 token
        tokenA = new ERC20Mock("Token A", "TKA");
        tokenB = new ERC20Mock("Token B", "TKB");

        // Deploy OrderBook and MatchingEngine and BatchAuction
        orderBook = new OrderBook();
        matchingEngine = new MatchingEngine(address(orderBook));
        orderBook.setMatcher(address(matchingEngine));
        batchAuction = new BatchAuction(address(orderBook), address(matchingEngine));

        // mint tokens to users
        tokenA.mint(user1, 1000 ether);
        tokenB.mint(user2, 1000 ether);
    }

    function testPlacedAndExecutedBatch() public {
        // User 1 place Buy order (TokenA -> TokenB)
        vm.startPrank(user1);
        tokenA.approve(address(batchAuction), 500 ether);
        orderBook.placeOrder(address(tokenA), address(tokenB), 500 ether, OrderBook.Side.Buy);
        vm.stopPrank();
        
        // User2 place sell order ( tokenB -> TokenA)
        vm.startPrank(user2);
        tokenB.approve(address(batchAuction), 500 ether);
        orderBook.placeOrder(address(tokenB), address(tokenA), 500 ether, OrderBook.Side.Sell);
        vm.stopPrank();

        // Execute batch
        batchAuction.executeBatch();

        // assert token were transferred to batchAuction
        assertEq(tokenA.balanceOf(address(batchAuction)), 500 ether);
        assertEq(tokenB.balanceOf(address(batchAuction)), 500 ether);
    }
}