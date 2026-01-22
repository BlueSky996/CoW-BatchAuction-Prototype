CoWScope – Batch Auction Prototype

This project is a simplified, educational implementation of a CoW Protocol–style batch auction built in Solidity.
It demonstrates how off-chain intent aggregation concepts can be expressed using on-chain components such as an order book, matching engine, and batch settlement logic.

The goal of this repository is protocol design demonstration, not a production-ready DEX.

✨ Overview

The system is composed of three main contracts:

OrderBook
Stores user orders and maintains their lifecycle.

MatchingEngine
Matches compatible buy and sell orders within a batch.

BatchAuction
Executes matched orders in a single batch and computes a uniform clearing price.

Orders are collected first, matched separately, and settled together — mirroring the core idea behind CoW-style batch auctions.

🧠 Design Philosophy

Clear separation of concerns

Gas-aware iteration patterns

Minimal state mutation

Explicit matching and settlement phases

Easy-to-audit control flow

This project intentionally avoids unnecessary complexity such as pricing curves, partial fills, or solver competition.

🔧 Contracts
OrderBook

Stores all submitted orders

Tracks order side (Buy / Sell)

Allows only the matching engine to mark orders as filled

MatchingEngine

Iterates through open orders

Matches compatible buy/sell pairs

Marks matched orders as filled

Emits match events for off-chain visibility

BatchAuction

Executes settlement for matched orders

Transfers tokenIn from users

Computes a simple uniform clearing price

Protected against reentrancy

🧪 Testing

The project uses Foundry for testing.

Covered scenarios:

Order placement

Order matching

Batch execution

Token transfers on settlement

Run tests with:

forge test


Verbose output:

forge test -vvv

🚧 Limitations (Intentional)

This is not a production DEX.

Missing by design:

Partial fills

Slippage protection

Price oracles

Solver competition

MEV protection

Signature-based off-chain orders

These features are intentionally excluded to keep the focus on core batch auction mechanics.

-- Why This Project ?

This repository exists to demonstrate:

Understanding of modern DEX architectures

Protocol-level thinking beyond simple swaps

Clean Solidity design with testing discipline


📜 License

MIT
