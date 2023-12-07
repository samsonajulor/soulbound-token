# SoulBoundToken

SoulBoundToken is an ERC-1155 token contract that allows the creation and transfer of unique items on the Ethereum blockchain. Each wallet can be soulbound, and only soulbound wallets can create and transfer specific items. The contract is built on the Solidity programming language and follows the ERC-1155 and Ownable standards.

## Features

- **Main Token and Items:** The contract includes a main token (ID: 1) and various items (IDs: 2-6). The main token is initially minted to the contract deployer, marking them as soulbound.

- **Soulbound Wallets:** Each wallet can be soulbound, and soulbound wallets are allowed to create and transfer items. The state of soulbound is tracked using a mapping.

- **Item Creation:** Soulbound wallets can create new item tokens (IDs: 2-6) by calling the `createItemToken` function, specifying the item ID and the quantity to be minted.

- **Transfer Restrictions:** The main token (ID: 1) is non-transferable. Item tokens can only be transferred by soulbound wallets, and the contract checks for sufficient balances before transfers.

## Token URI

The contract follows the ERC-1155 standard by providing a token URI for each token ID. The URI is constructed as follows: "https://abcoathup.github.io/SampleERC1155/api/token/{id}.json". This URI can be used to retrieve metadata about each token.

## Usage

1. **Deploy the Contract:** Deploy the SoulBoundToken contract to the Ethereum blockchain.

2. **Soulbinding:** The deployment wallet is automatically soulbound upon contract creation. To soulbind additional wallets, call the `obtainSoulboundMainToken` function.

3. **Item Creation:** Soulbound wallets can create new item tokens using the `createItemToken` function, specifying the item ID and quantity.

4. **Item Transfer:** Soulbound wallets can safely transfer item tokens using the `safeTransferItemToken` function, ensuring the transfer adheres to the contract's rules.

## Installation

To use this contract in your project, you can import it into your Solidity code as follows:

```solidity
import "./path/to/SoulBoundToken.sol";
```

Make sure to replace the path with the actual location of the `SoulBoundToken.sol` file in your project.

## License

This contract is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


# How to Install
- clone this repository `git clone <repo url>`
- run `forge install` to install deps
- run `forge build` to build the application
- run `forge test` to run the tests.

This Contract is deployed to base @ 0x7d3DE2385CbCe0Bc4031cBD30F4CB0daf843A6a6
tx-hash 0x49410b2d0e3a77b4dfbb9216ab4beba90c0c34162ed17ef30342bad6ebc57237