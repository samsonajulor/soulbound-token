// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";


contract SoulBoundToken is ERC1155, Ownable {
    uint256 public constant MAIN_TOKEN_ID = 1;
    uint256 public constant GOLD = 2;
    uint256 public constant SILVER = 3;
    uint256 public constant THORS_HAMMER = 4;
    uint256 public constant SWORD = 5;
    uint256 public constant SHIELD = 6;

    mapping(address => bool) public isSoulbound;

    event Soulbound(address indexed wallet);

    constructor() ERC1155("https://abcoathup.github.io/SampleERC1155/api/token/{id}.json") {
        _mint(msg.sender, MAIN_TOKEN_ID, 1, "");

        isSoulbound[msg.sender] = true;

        emit Soulbound(msg.sender);
    }

    modifier onlySoulbound() {
        require(isSoulbound[msg.sender], "Caller is not soulbound");
        _;
    }

    function obtainSoulboundMainToken() external {
        require(!isSoulbound[msg.sender], "Wallet already owns the soulbound main token");
        require(balanceOf(msg.sender, MAIN_TOKEN_ID) == 0, "Wallet already has the main token");

        _mint(msg.sender, MAIN_TOKEN_ID, 1, "");

        isSoulbound[msg.sender] = true;

        emit Soulbound(msg.sender);
    }

    function createItemToken(uint256 itemId, uint256 amount) external onlySoulbound {
        require(itemId != MAIN_TOKEN_ID, "MAIN_TOKEN cannot be created");
        require(itemId != GOLD, "GOLD cannot be created");
        require(itemId != SILVER, "SILVER cannot be created");
        require(itemId != THORS_HAMMER, "THORS_HAMMER cannot be created");
        require(itemId != SWORD, "SWORD cannot be created");
        require(itemId != SHIELD, "SHIELD cannot be created");
        _mint(msg.sender, itemId, amount, "");
    }

    function safeTransferItemToken(
        address from,
        address to,
        uint256 itemId,
        uint256 amount,
        bytes memory data
    ) external onlySoulbound {
        // make the MAIN_TOKEN non transferable
        require(itemId != MAIN_TOKEN_ID, "MAIN_TOKEN cannot be transfered");
        require(balanceOf(from, itemId) >= amount, "ERC1155: insufficient balance for transfer");
        safeTransferFrom(from, to, itemId, amount, data);
    }
}
