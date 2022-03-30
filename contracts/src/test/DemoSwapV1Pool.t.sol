// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoSwapV1Common} from "./DemoSwapV1Common.t.sol";
import {DemoSwapV1, InvalidTokenPair} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

contract DemoSwapV1Pool is DemoSwapV1Common {
    function setUp() public override {
        super.setUp();
        _setSwapContractWithFee(0);
    }

    function testPoolBalancing() public {
        testPoolBalancingFuzz(1e18);
    }

    function testPoolBalancingFuzz(uint256 _inAmt) public {
        uint256 poolAAmt = 1e12 * 1e18;
        uint256 poolBAmt = 1e12 * 1e18;

        // A zero trade won't imbalance the pool
        VM.assume(_inAmt > 0);
        // Trade can't be larger than the pool
        VM.assume(_inAmt <= poolAAmt);

        _mintAndDeposit(_lp1, poolAAmt, poolBAmt);

        // trade A => B
        _mintAndSwap(_tokenA, _tokenB, _inAmt);
        assertEq(_tokenA.balanceOf(address(_swap)), poolAAmt + _inAmt);
        assertLt(_tokenB.balanceOf(address(_swap)), poolBAmt);

        // trade B => A, bringing pools back into balance
        uint256 balAmt = poolBAmt - _tokenB.balanceOf(address(_swap));
        _mintAndSwap(_tokenB, _tokenA, balAmt);
        assertEq(_tokenA.balanceOf(address(_swap)), poolAAmt);
        assertEq(_tokenB.balanceOf(address(_swap)), poolBAmt);
    }

    function test() public {
        uint256 poolAAmt = 1e12 * 1e18;
        uint256 poolBAmt = 1e12 * 1e18;
        uint256 inAmt = 1e9 * 1e18;

        _mintAndDeposit(_lp1, poolAAmt, poolBAmt);

        uint256 share;

        share = FixedPointMathLib.divWadDown(
            _swap.lpToken().balanceOf(_lp1),
            _swap.lpToken().totalSupply()
        );
        emit log_named_decimal_uint("_lp1 share", share, 18);

        // trade A => B
        _mintAndSwap(_tokenA, _tokenB, inAmt);
        assertEq(_tokenA.balanceOf(address(_swap)), poolAAmt + inAmt);
        assertLt(_tokenB.balanceOf(address(_swap)), poolBAmt);

        _mintAndDeposit(_lp2, poolAAmt, poolBAmt);

        share = FixedPointMathLib.divWadDown(
            _swap.lpToken().balanceOf(_lp1),
            _swap.lpToken().totalSupply()
        );
        emit log_named_decimal_uint("_lp1 share", share, 18);

        share = FixedPointMathLib.divWadDown(
            _swap.lpToken().balanceOf(_lp2),
            _swap.lpToken().totalSupply()
        );
        emit log_named_decimal_uint("_lp2 share", share, 18);

        emit log_named_uint("test", FixedPointMathLib.sqrt(1e18 * 1e18));
        emit log_named_uint("test", FixedPointMathLib.mulWadUp(1e18, 1e18));

        // VM.startPrank(_lp1);
        // _swap.withdraw(_swap.lpToken().balanceOf(_lp1));
        // VM.stopPrank();
        // assertEq(_swap.lpToken().balanceOf(_lp1), 0);
        // assertEq(_tokenA.balanceOf(_lp1), 1e12 * 1e18);
        // assertEq(_tokenB.balanceOf(_lp1), 1e12 * 1e18);
    }

    function testDeposit() public {
        _mintAndDeposit(_lp1, 1e12 * 1e18, 1e12 * 1e18);
        assertEq(_tokenA.balanceOf(_lp1), 0);
        assertEq(_tokenB.balanceOf(_lp1), 0);
        assertEq(_swap.lpToken().balanceOf(_lp1), 1e12 * 1e18);
    }

    function testDepositFuzz(uint256 _tokenAAmt, uint256 _tokenBAmt) public {
        // We *will* get overflows for very large amounts so let's limit them
        VM.assume(_tokenAAmt <= 1e12 * 1e18);
        VM.assume(_tokenBAmt <= 1e12 * 1e18);

        _mintAndDeposit(_lp1, _tokenAAmt, _tokenBAmt);
        assertEq(
            _swap.lpToken().balanceOf(_lp1),
            FixedPointMathLib.sqrt(_tokenAAmt * _tokenBAmt)
        );
    }

    function testWithdraw() public {
        _mintAndDeposit(_lp1, 1e12 * 1e18, 1e12 * 1e18);
        VM.startPrank(_lp1);
        _swap.withdraw(_swap.lpToken().balanceOf(_lp1));
        VM.stopPrank();
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
        _mintAndDeposit(_lp1, 1, 1);
        VM.startPrank(_lp1);
        _swap.withdraw(_swap.lpToken().balanceOf(_lp1));
        VM.stopPrank();
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

        _mintAndDeposit(_lp1, _tokenAAmt, _tokenBAmt);
        VM.startPrank(_lp1);
        _swap.withdraw(_swap.lpToken().balanceOf(_lp1));
        VM.stopPrank();
        assertEq(_swap.lpToken().balanceOf(_lp1), 0);
        assertEq(_tokenA.balanceOf(_lp1), 1e12 * 1e18);
        assertEq(_tokenB.balanceOf(_lp1), 1e12 * 1e18);
    }

    function testWithdrawTooMuch() public {
        _mintAndDeposit(_lp1, 1e12 * 1e18, 1e12 * 1e18);
        uint256 lpTokAmt = _swap.lpToken().balanceOf(_lp1);
        VM.expectRevert(ERROR_UNDER_OVERFLOW);
        VM.prank(_lp1);
        _swap.withdraw(lpTokAmt + 1);
    }
}
