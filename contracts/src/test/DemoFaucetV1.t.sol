// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {DemoFaucetV1, MaxTokensClaimed} from "../DemoFaucetV1.sol";

contract DemoFaucetV1Test is DSTestPlus {
    address payable private _owner;
    address payable private _user;
    DemoERC20V1 private _token;
    DemoFaucetV1 private _faucet;

    function setUp() public {
        _owner = payable(VM.addr(0xCA55E77E));
        _user = payable(VM.addr(0xDECAFBAD));
        _token = new DemoERC20V1("Token", "TOK", 18, _owner);
        _faucet = new DemoFaucetV1(_token);
        VM.prank(_owner);
        _token.mint(address(_faucet), type(uint256).max);

        VM.label(address(this), "test");
        VM.label(_owner, "owner");
        VM.label(_user, "user");
        VM.label(address(_token), "token");
        VM.label(address(_faucet), "faucet");
    }

    function testMint() public {
        assertEq(_token.balanceOf(address(_faucet)), type(uint256).max);
    }

    function testClaim() public {
        assertEq(_token.balanceOf(address(_user)), 0);
        VM.prank(_user);
        _faucet.claim();
        assertEq(_token.balanceOf(address(_user)), 100 * 1e18);
    }

    function testClaimAll() public {
        VM.startPrank(_user);
        for (uint256 i = 0; i < 10; i++) {
            _faucet.claim();
        }
        VM.stopPrank();
        assertEq(_token.balanceOf(address(_user)), 1000 * 1e18);
    }

    function testClaimTooMuch() public {
        VM.startPrank(_user);
        for (uint256 i = 0; i < 10; i++) {
            _faucet.claim();
        }
        VM.stopPrank();
        VM.expectRevert(MaxTokensClaimed.selector);
        VM.prank(_user);
        _faucet.claim();
    }
}
