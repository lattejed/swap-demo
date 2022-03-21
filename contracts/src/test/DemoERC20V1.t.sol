// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import { DSTestPlus } from "./utils/DSTestPlus.sol";
import { DemoERC20V1 } from "../DemoERC20V1.sol";

contract DemoERC20V1Test is DSTestPlus {
    address payable private _owner;
    DemoERC20V1 private _token;

    function setUp() public {
        _owner = payable(vm.addr(0xCA55E77E));
        _token = new DemoERC20V1("Token", "TOK", 18, _owner);
    }

    function testInvariantMetadata() public {
        assertEq(_token.name(), "Token");
        assertEq(_token.symbol(), "TOK");
        assertEq(_token.decimals(), 18);
    }

    function testMint() public {
        assertEq(_token.balanceOf(address(_owner)), 0);
        vm.prank(_owner);
        _token.mint(address(_owner), 1e18);
        assertEq(_token.balanceOf(address(_owner)), 1e18);
    }

    function testBadMint() public {
        vm.expectRevert(DemoERC20V1.InvalidSenderAddress.selector);
        _token.mint(address(_owner), 1e18);
    }
}
