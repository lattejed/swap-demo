// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoSwapV1Common} from "./DemoSwapV1Common.t.sol";
import {DemoSwapV1, InvalidTokenPair} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

contract DemoSwapV1Pool is DemoSwapV1Common {
    function setUp() public override {
        super.setUp();
        //
    }

    /*
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
    */
}
