// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoSwapV1} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

contract DemoSwapV1Test is DSTestPlus {
    address payable private _owner;
    address payable private _lp1;
    address payable private _user;
    DemoERC20V1 private _tokenA;
    DemoERC20V1 private _tokenB;
    DemoSwapV1 private _swap;

    function setUp() public {
        _owner = payable(VM.addr(0xCA55E77E));
        _lp1 = payable(VM.addr(0xDECAFBAD));
        _user = payable(VM.addr(0xBADDECAF));
        _tokenA = new DemoERC20V1("Token A", "TKA", 18, _owner);
        _tokenB = new DemoERC20V1("Token B", "TKB", 18, _owner);
        VM.startPrank(_owner);
        _tokenA.mint(_lp1, 1e12 * 1e18);
        _tokenB.mint(_lp1, 1e12 * 1e18);
        VM.stopPrank();
        _swap = new DemoSwapV1(_tokenA, _tokenB, "Token LP", "TLP", 18);

        VM.label(address(this), "test");
        VM.label(_owner, "owner");
        VM.label(_lp1, "_lp1");
        VM.label(_user, "user");
        VM.label(address(_tokenA), "tokenA");
        VM.label(address(_tokenB), "tokenB");
        VM.label(address(_swap.lpToken()), "tokenLP");
        VM.label(address(_swap), "swap");
    }

    function testBalances() public {
        assertEq(_tokenA.balanceOf(address(_lp1)), 1e12 * 1e18);
        assertEq(_tokenB.balanceOf(address(_lp1)), 1e12 * 1e18);
    }

    function testSwap() public {}

    function testDeposit() public {
        _deposit(1e12 * 1e18, 1e12 * 1e18);
        assertEq(_tokenA.balanceOf(_lp1), 0);
        assertEq(_tokenB.balanceOf(_lp1), 0);
        assertEq(_swap.lpToken().balanceOf(_lp1), 1e12 * 1e18);
    }

    function testDepositFuzz(uint256 _tokenAAmt, uint256 _tokenBAmt) public {
        // We *will* get overflows for very large amounts so let's limit them
        VM.assume(_tokenAAmt <= 1e12 * 1e18);
        VM.assume(_tokenBAmt <= 1e12 * 1e18);

        _deposit(_tokenAAmt, _tokenBAmt);
        assertEq(
            _swap.lpToken().balanceOf(_lp1),
            FixedPointMathLib.sqrt(_tokenAAmt * _tokenBAmt)
        );
    }

    function testWithdraw() public {
        _deposit(1e12 * 1e18, 1e12 * 1e18);
        VM.prank(_lp1);
        _swap.withdraw(FixedPointMathLib.sqrt(1e12 * 1e18 * 1e12 * 1e18));
        assertEq(_swap.lpToken().balanceOf(_lp1), 0);
        assertEq(_tokenA.balanceOf(_lp1), 1e12 * 1e18);
        assertEq(_tokenB.balanceOf(_lp1), 1e12 * 1e18);
    }

    function testWithdrawZero() public {
        VM.expectRevert(ERROR_NULL);
        VM.prank(_lp1);
        _swap.withdraw(0);
    }

    function testWithdrawOne() public {
        _deposit(1, 1);
        VM.prank(_lp1);
        _swap.withdraw(FixedPointMathLib.sqrt(1 * 1));
        assertEq(_swap.lpToken().balanceOf(_lp1), 0);
        assertEq(_tokenA.balanceOf(_lp1), 1e12 * 1e18);
        assertEq(_tokenB.balanceOf(_lp1), 1e12 * 1e18);
    }

    function testWithdrawFuzz(uint256 _tokenAAmt, uint256 _tokenBAmt) public {
        // We *will* get overflows for very large amounts so let's limit them
        VM.assume(_tokenAAmt <= 1e12 * 1e18);
        VM.assume(_tokenBAmt <= 1e12 * 1e18);
        // testWithdrawZero handles a zero withdrawal
        VM.assume(_tokenAAmt > 0 && _tokenBAmt > 0);

        _deposit(_tokenAAmt, _tokenBAmt);
        VM.prank(_lp1);
        _swap.withdraw(FixedPointMathLib.sqrt(_tokenAAmt * _tokenBAmt));
        assertEq(_swap.lpToken().balanceOf(_lp1), 0);
        assertEq(_tokenA.balanceOf(_lp1), 1e12 * 1e18);
        assertEq(_tokenB.balanceOf(_lp1), 1e12 * 1e18);
    }

    function testWithdrawTooMuch() public {
        _deposit(1e12 * 1e18, 1e12 * 1e18);
        VM.expectRevert(ERROR_UNDER_OVERFLOW);
        VM.prank(_lp1);
        _swap.withdraw(FixedPointMathLib.sqrt(1e12 * 1e18 * 1e12 * 1e18) + 1);
    }

    function _deposit(uint256 _tokenAAmt, uint256 _tokenBAmt) private {
        VM.startPrank(_lp1);
        _tokenA.approve(address(_swap), _tokenAAmt);
        _tokenB.approve(address(_swap), _tokenBAmt);
        _swap.deposit(_tokenAAmt, _tokenBAmt);
        VM.stopPrank();
    }
}
