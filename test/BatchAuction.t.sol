// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol;
import "../backend/contracts/BatchAuction.sol";
import "../backend/contracts/OrderBook.sol";
import "../backend/contracts/MatchingEngine.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BatchAuctionTest is Test {

    OrderBook orderBook;
    MatchingEngine matchingEngine;
    BatchAuction batchauction;
    ERC20 token;

    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        // Deploy Erc20 token
        token = new ERC20("test Token", "TST");

        // Deploy OrderBook and MatchingEngine
        orderBook = new OrderBook();
        matchingEngine = new MatchingEngine(address(orderBook));

        //Deploy BatchAuction
        batchAuction = new BatchAuction(address(orderBook), address(matchingEngine));

        // mint tokens to users
        token.mint(user1, 1000 ether);
        token.mint(user2, 1000 ether)
    }

    function testPlacedAndExecutedBatch() public {
        vm.startPrank(user1);
        token.approve(address(batchAuction), 500 ether);
        orderBook.placedOrder(address(token), address(token), 500 ether, OrderBook.Side.Buy);
        vm.stopPrank();

        vm.startPrank(user2);
        token.approve(address(batchAuction), 500 ether);
        orderBook.placeOrder(address(token), address(token), 500 ether, OrderBook.Side.Sell);
        vm.stopPrank();

        // Execute batch
        batchAuction.executeBatch();

        // Check clearing price
        uint256 price = batchAuction.computClearingPrice();
        assertEq(price, 500 ether);
    }
}