// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoSwapV1} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";

contract DemoSwapV1Test is DSTestPlus {
    address payable private _owner;
    address payable private _user;
    DemoERC20V1 private _tokenA;
    DemoERC20V1 private _tokenB;
    DemoSwapV1 private _swap;

    function setUp() public {
        _owner = payable(VM.addr(0xCA55E77E));
        _user = payable(VM.addr(0xDECAFBAD));
        _tokenA = new DemoERC20V1("Token A", "TKA", 18, _owner);
        _tokenB = new DemoERC20V1("Token B", "TKB", 18, _owner);
        VM.startPrank(_owner);
        _tokenA.mint(_user, 100 * 1e18);
        _tokenB.mint(_user, 100 * 1e18);
        VM.stopPrank();
        _swap = new DemoSwapV1(_tokenA, _tokenB);

        VM.label(address(this), "test");
        VM.label(_owner, "owner");
        VM.label(_user, "user");
        VM.label(address(_tokenA), "tokenA");
        VM.label(address(_tokenB), "tokenB");
        VM.label(address(_swap), "swap");
    }

    function testBalances() public {
        assertEq(_tokenA.balanceOf(address(_user)), 100 * 1e18);
        assertEq(_tokenB.balanceOf(address(_user)), 100 * 1e18);
    }

    function testDeposit() public {
        VM.prank(_user);
        _swap.deposit(100 * 1e18, 100 * 1e18);
    }
}
