// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "../lib/forge-std/src/Test.sol";
import {SoulBoundToken} from "../src/SoulBoundToken.sol";

interface IERC1155Receiver {
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);
}

contract ForwarderERC1155Receiver is IERC1155Receiver {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC1155Receiver(target).onERC1155Received(operator, from, id, value, data);
    }
}

contract ForwarderERC1155Receiver2 is IERC1155Receiver {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC1155Receiver(target).onERC1155Received(operator, from, id, value, data);
    }
}


contract SoulBoundTokenTest is Test {
    uint256 public constant MAIN_TOKEN_ID = 1;
    // uint256 user
    function mkaddr(
        string memory name
    ) public returns (address addr, uint256 privateKey) {
        privateKey = uint256(keccak256(abi.encodePacked(name)));
        // address addr = address(uint160(uint256(keccak256(abi.encodePacked(name)))))
        addr = vm.addr(privateKey);
        vm.label(addr, name);
    }

    function switchSigner(address _newSigner) public {
        vm.startPrank(_newSigner);
        vm.deal(_newSigner, 4 ether);
    }

    SoulBoundToken public soulBoundTokenContract;
    address _user = address(0x11111);
    address _user2 = address(0x22222);

    address _wallet = address(new ForwarderERC1155Receiver(_user));

    address _wallet2 = address(new ForwarderERC1155Receiver2(_user2));

    uint256 _privKeyA;

    function setUp() public {
        (_wallet, _privKeyA) = mkaddr("WALLET");

        (_wallet2, _privKeyA) = mkaddr("WALLET2");

        switchSigner(_wallet2);

        soulBoundTokenContract = new SoulBoundToken();

        vm.stopPrank();
    }

    function testObtainSoulBoundToken() public {
        switchSigner(_wallet);
        soulBoundTokenContract.obtainSoulboundMainToken();

        assertEq(soulBoundTokenContract.balanceOf(_wallet, MAIN_TOKEN_ID), 1);
    }

    function testWalletCannotObtainSoulBoundToken() public {
        switchSigner(_wallet2);

        vm.expectRevert(SoulBoundToken.AlreadySoulbound.selector);
        soulBoundTokenContract.obtainSoulboundMainToken();
    }

    function testCannotCreateMainToken() public {
        switchSigner(_wallet2);
        vm.expectRevert(SoulBoundToken.CannotCreateMainToken.selector);
        soulBoundTokenContract.createItemToken(MAIN_TOKEN_ID, 1);
    }

    function testCannotTransferMainToken() public {
        switchSigner(_wallet2);
        vm.expectRevert(SoulBoundToken.CannotTransferMainToken.selector);
        soulBoundTokenContract.safeTransferItemToken(_wallet, _wallet2, MAIN_TOKEN_ID, 1, "");
    }
}
