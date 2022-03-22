// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoERC20V1, InvalidSenderAddress} from "../DemoERC20V1.sol";

contract DemoERC20V1Test is DSTestPlus {
    address payable private _owner;
    DemoERC20V1 private _token;

    function setUp() public {
        _owner = payable(VM.addr(0xCA55E77E));
        _token = new DemoERC20V1("Token", "TOK", 18, _owner);
    }

    function testInvariantMetadata() public {
        assertEq(_token.name(), "Token");
        assertEq(_token.symbol(), "TOK");
        assertEq(_token.decimals(), 18);
    }

    function testMint() public {
        assertEq(_token.balanceOf(address(_owner)), 0);
        VM.prank(_owner);
        _token.mint(address(_owner), 1e18);
        assertEq(_token.balanceOf(address(_owner)), 1e18);
    }

    function testBadMint() public {
        VM.expectRevert(
            abi.encodeWithSelector(InvalidSenderAddress.selector, address(this))
        );
        _token.mint(address(_owner), 1e18);
    }
}
