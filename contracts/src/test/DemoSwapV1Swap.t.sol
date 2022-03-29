// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoSwapV1Common} from "./DemoSwapV1Common.t.sol";
import {DemoSwapV1, InvalidTokenPair} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

contract DemoSwapV1Swap is DemoSwapV1Common {
    function setUp() public override {
        super.setUp();
        //
    }

    function testSwapBadPair() public {
        VM.expectRevert(InvalidTokenPair.selector);
        _swap.swap(address(_tokenA), address(_tokenA), 1e18);
        VM.expectRevert(InvalidTokenPair.selector);
        _swap.swap(address(0), address(0), 1e18);
    }

    function testSwapMin() public {
        _mintAndDeposit(_lp1, 1e12 * 1e18, 1e12 * 1e18);
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

        _mintAndDeposit(_lp1, 1e12 * 1e18, 1e12 * 1e18);
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
        _mintAndDeposit(_lp1, 1e12 * 1e18, 1e12 * 1e18);
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
}
