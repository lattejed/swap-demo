// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoSwapV1, InvalidTokenPair} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

contract DemoSwapV1Common is DSTestPlus {
    address payable internal _owner;
    address payable internal _lp1;
    address payable internal _user;
    DemoERC20V1 internal _tokenA;
    DemoERC20V1 internal _tokenB;
    DemoSwapV1 internal _swap;

    function setUp() public virtual {
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

    function _deposit(uint256 _tokenAAmt, uint256 _tokenBAmt) internal {
        VM.startPrank(_lp1);
        _tokenA.approve(address(_swap), _tokenAAmt);
        _tokenB.approve(address(_swap), _tokenBAmt);
        _swap.deposit(_tokenAAmt, _tokenBAmt);
        VM.stopPrank();
    }
}
