// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoSwapV1} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

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
        _tokenA.mint(_user, 1e12 * 1e18);
        _tokenB.mint(_user, 1e12 * 1e18);
        VM.stopPrank();
        _swap = new DemoSwapV1(_tokenA, _tokenB, "Token LP", "TLP", 18);

        VM.label(address(this), "test");
        VM.label(_owner, "owner");
        VM.label(_user, "user");
        VM.label(address(_tokenA), "tokenA");
        VM.label(address(_tokenB), "tokenB");
        VM.label(address(_swap.lpToken()), "tokenLP");
        VM.label(address(_swap), "swap");
    }

    function testBalances() public {
        assertEq(_tokenA.balanceOf(address(_user)), 1e12 * 1e18);
        assertEq(_tokenB.balanceOf(address(_user)), 1e12 * 1e18);
    }

    function testDeposit() public {
        _deposit(1e12 * 1e18, 1e12 * 1e18);
        assertEq(_tokenA.balanceOf(_user), 0);
        assertEq(_tokenB.balanceOf(_user), 0);
        assertEq(_swap.lpToken().balanceOf(_user), 1e12 * 1e18);
    }

    function testDepositFuzz(uint256 _tokenAAmt, uint256 _tokenBAmt) public {
        // We *will* get overflows for very large amounts so let's limit them
        VM.assume(_tokenAAmt <= 1e12 * 1e18);
        VM.assume(_tokenBAmt <= 1e12 * 1e18);
        _deposit(_tokenAAmt, _tokenBAmt);
        assertEq(
            _swap.lpToken().balanceOf(_user),
            FixedPointMathLib.sqrt(_tokenAAmt * _tokenBAmt)
        );
    }

    function testWithdraw() public {
        _deposit(1e12 * 1e18, 1e12 * 1e18);
        VM.prank(_user);
        _swap.withdraw(1e12 * 1e18);
        assertEq(_swap.lpToken().balanceOf(_user), 0);
        assertEq(_tokenA.balanceOf(_user), 1e12 * 1e18);
        assertEq(_tokenB.balanceOf(_user), 1e12 * 1e18);
    }

    function testWithdrawZero() public {
        VM.expectRevert(bytes("")); // FixedPointMathLib.divWadUp revert
        VM.prank(_user);
        _swap.withdraw(0);
    }

    function testWithdrawFuzz(uint256 _tokenAAmt, uint256 _tokenBAmt) public {
        // testWithdrawZero handles a zero withdrawal
        VM.assume(_tokenAAmt > 0);
        VM.assume(_tokenBAmt > 0);
        // We *will* get overflows for very large amounts so let's limit them
        VM.assume(_tokenAAmt <= 1e12 * 1e18);
        VM.assume(_tokenBAmt <= 1e12 * 1e18);
        _deposit(_tokenAAmt, _tokenBAmt);
        VM.prank(_user);
        _swap.withdraw(_tokenAAmt * _tokenBAmt);
        assertEq(_swap.lpToken().balanceOf(_user), 0);
        assertEq(_tokenA.balanceOf(_user), _tokenAAmt);
        assertEq(_tokenB.balanceOf(_user), _tokenBAmt);
    }

    function _deposit(uint256 _tokenAAmt, uint256 _tokenBAmt) private {
        VM.startPrank(_user);
        _tokenA.approve(address(_swap), _tokenAAmt);
        _tokenB.approve(address(_swap), _tokenBAmt);
        _swap.deposit(_tokenAAmt, _tokenBAmt);
        VM.stopPrank();
    }
}
