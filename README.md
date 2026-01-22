CoWScope – Batch Auction Prototype

A simplified, educational implementation of a CoW Protocol–style batch auction written in Solidity.

This repository demonstrates how off-chain intent aggregation concepts can be expressed using on-chain components such as an order book, a matching engine, and batch settlement logic.

The goal of this project is protocol design demonstration, not a production-ready decentralized exchange.

Overview

The system is composed of three main contracts:

OrderBook

Stores user orders

Maintains order lifecycle and state

MatchingEngine

Matches compatible buy and sell orders within a batch

Emits match events for off-chain visibility

BatchAuction

Executes matched orders in a single batch

Computes a uniform clearing price

Settles all matched orders atomically

Orders are collected first, matched separately, and settled together.
This mirrors the core idea behind CoW-style batch auctions.

Design Philosophy

Clear separation of concerns

Gas-aware iteration patterns

Minimal state mutation

Explicit matching and settlement phases

Easy-to-audit control flow

This project intentionally avoids unnecessary complexity such as pricing curves, partial fills, or solver competition.

Contracts
OrderBook

Stores all submitted orders

Tracks order side (Buy / Sell)

Restricts order settlement to the matching engine

MatchingEngine

Iterates through open orders

Matches compatible buy and sell pairs

Marks matched orders as filled

Emits match events

BatchAuction

Executes settlement for matched orders

Transfers tokenIn from users

Computes a simple uniform clearing price

Protected against reentrancy

Testing

The project uses Foundry for testing.

Covered scenarios:

Order placement

Order matching

Batch execution

Token transfers on settlement

Run tests:

forge test


Verbose output:

forge test -vvv

Limitations (Intentional)

This is not a production DEX.

The following features are intentionally excluded:

Partial fills

Slippage protection

Price oracles

Solver competition

MEV protection

Signature-based off-chain orders

The focus is kept strictly on core batch auction mechanics.

Why This Project

This repository exists to demonstrate:

Understanding of modern DEX architectures

Protocol-level thinking beyond simple swaps

Clean Solidity design with proper testing discipline

It is intended as a technical portfolio and research prototype.

License

MIT
