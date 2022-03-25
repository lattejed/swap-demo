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
        _swap = new DemoSwapV1(_tokenA, _tokenB, "Token LP", "TLP", 18, 3);

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

    function testSwapMin() public {
        _deposit(1e12 * 1e18, 1e12 * 1e18);
        uint256 inAmt = 10;
        // This is the same with or without fee
        uint256 outAmt = 9;
        VM.prank(_owner);
        _tokenA.mint(_user, inAmt);
        VM.startPrank(_user);
        _tokenA.approve(address(_swap), inAmt);
        _swap.swap(address(_tokenA), address(_tokenB), inAmt);
        VM.stopPrank();
        assertEq(_tokenB.balanceOf(_user), outAmt);
    }

    function testSwapZero() public {
        VM.expectRevert(ERROR_NULL);
        VM.prank(_user);
        _swap.swap(address(_tokenA), address(_tokenB), 0);
    }

    function testSwap() public {
        testSwapFuzz(1000000000000000000);
    }

    function testSwapFuzz(uint256 _inAmt) public {
        VM.assume(_inAmt <= 1e12 * 1e18);

        _deposit(1e12 * 1e18, 1e12 * 1e18);
        uint256 grossAmt = (1e12 * 1e18) -
            FixedPointMathLib.divWadUp(
                FixedPointMathLib.mulWadUp(1e12 * 1e18, 1e12 * 1e18),
                1e12 * 1e18 + _inAmt
            );
        uint256 g = 1e18 - 3 * 1e15;
        uint256 netAmt = FixedPointMathLib.mulWadUp(grossAmt, g);
        VM.prank(_owner);
        _tokenA.mint(_user, _inAmt);
        VM.startPrank(_user);
        _tokenA.approve(address(_swap), _inAmt);
        _swap.swap(address(_tokenA), address(_tokenB), _inAmt);
        VM.stopPrank();
        assertEq(_tokenB.balanceOf(_user), netAmt);
    }

    function testSwapEstimate() public {
        _deposit(1e12 * 1e18, 1e12 * 1e18);
        uint256 grossAmt = (1e12 * 1e18) -
            FixedPointMathLib.divWadUp(
                FixedPointMathLib.mulWadUp(1e12 * 1e18, 1e12 * 1e18),
                1e12 * 1e18 + 1000000000000000000
            );
        uint256 g = 1e18 - 3 * 1e15;
        uint256 netAmt = FixedPointMathLib.mulWadUp(grossAmt, g);
        uint256 inAmt = 1000000000000000000;
        assertEq(
            _swap.swapEstimate(address(_tokenA), address(_tokenB), inAmt),
            netAmt
        );
        assertEq(
            _swap.swapEstimate(address(_tokenB), address(_tokenA), inAmt),
            netAmt
        );
    }

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
