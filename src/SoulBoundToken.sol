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

    // Custom errors
    error AlreadySoulbound();
    error AlreadyOwnsMainToken();
    error CannotCreateMainToken();
    error ItemAlreadyExists(uint256 itemId);
    error InsufficientBalanceForTransfer();
    error CannotTransferMainToken();

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
        if (isSoulbound[msg.sender])
            revert AlreadySoulbound();

        if (balanceOf(msg.sender, MAIN_TOKEN_ID) > 0)
            revert AlreadyOwnsMainToken();

        _mint(msg.sender, MAIN_TOKEN_ID, 1, "");
        isSoulbound[msg.sender] = true;
        emit Soulbound(msg.sender);
    }

    function createItemToken(uint256 itemId, uint256 amount) external onlySoulbound {
        if (itemId == MAIN_TOKEN_ID)
            revert CannotCreateMainToken();

        if (itemId == GOLD || itemId == SILVER || itemId == THORS_HAMMER || itemId == SWORD || itemId == SHIELD)
            revert ItemAlreadyExists(itemId);

        _mint(msg.sender, itemId, amount, "");
    }

    function safeTransferItemToken(
        address from,
        address to,
        uint256 itemId,
        uint256 amount,
        bytes memory data
    ) external onlySoulbound {
        if (itemId == MAIN_TOKEN_ID)
            revert CannotTransferMainToken();

        if (balanceOf(from, itemId) < amount)
            revert InsufficientBalanceForTransfer();

        safeTransferFrom(from, to, itemId, amount, data);
    }
}
