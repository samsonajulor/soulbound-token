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

contract TestWallet is IERC1155Receiver {

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {

        console2.log("TestWallet: onERC1155Received");
        return IERC1155Receiver(0x0000000000000000000000000000000000000000).onERC1155Received(
            operator,
            from,
            id,
            value,
            data
        );
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

    address _wallet = address(new TestWallet());

    uint256 _privKeyA;

    function setUp() public {
        (_wallet, _privKeyA) = mkaddr("WALLET");

        soulBoundTokenContract = new SoulBoundToken();
    }

    function testObtainSoulBoundToken() public {
        switchSigner(_wallet);
        soulBoundTokenContract.obtainSoulboundMainToken();

        assertEq(soulBoundTokenContract.balanceOf(_wallet, MAIN_TOKEN_ID), 1);
    }
}
