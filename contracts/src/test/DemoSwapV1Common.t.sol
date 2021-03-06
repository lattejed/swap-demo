// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoSwapV1, InvalidTokenPair} from "../DemoSwapV1.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

contract DemoSwapV1Common is DSTestPlus {
    address payable internal _owner;
    address payable internal _lp1;
    address payable internal _lp2;
    address payable internal _user;
    DemoERC20V1 internal _tokenA;
    DemoERC20V1 internal _tokenB;
    DemoSwapV1 internal _swap;

    function setUp() public virtual {
        _owner = payable(VM.addr(0xCA55E77E));
        _lp1 = payable(VM.addr(0xDECAFBAD));
        _lp2 = payable(VM.addr(0xE77ECA55));
        _user = payable(VM.addr(0xBADDECAF));
        _tokenA = new DemoERC20V1("Token A", "TKA", 18, _owner);
        _tokenB = new DemoERC20V1("Token B", "TKB", 18, _owner);

        VM.label(address(this), "test");
        VM.label(_owner, "owner");
        VM.label(_lp1, "_lp1");
        VM.label(_lp2, "_lp2");
        VM.label(_user, "user");
        VM.label(address(_tokenA), "tokenA");
        VM.label(address(_tokenB), "tokenB");
    }

    function _setSwapContractWithFee(uint8 _fee) internal {
        _swap = new DemoSwapV1(_tokenA, _tokenB, "Token LP", "TLP", 18, _fee);
        VM.label(address(_swap.lpToken()), "tokenLP");
        VM.label(address(_swap), "swap");
    }

    function _mintAndDeposit(
        address _lp,
        uint256 _tokenAAmt,
        uint256 _tokenBAmt
    ) internal {
        VM.startPrank(_owner);
        _tokenA.mint(_lp, _tokenAAmt);
        _tokenB.mint(_lp, _tokenBAmt);
        VM.stopPrank();
        VM.startPrank(_lp);
        _tokenA.approve(address(_swap), _tokenAAmt);
        _tokenB.approve(address(_swap), _tokenBAmt);
        _swap.deposit(_tokenAAmt, _tokenBAmt);
        VM.stopPrank();
    }

    function _mintAndSwap(
        DemoERC20V1 _token1,
        DemoERC20V1 _token2,
        uint256 _amount
    ) internal {
        VM.prank(_owner);
        _token1.mint(_user, _amount);
        VM.startPrank(_user);
        _token1.approve(address(_swap), _amount);
        _swap.swap(address(_token1), address(_token2), _amount);
        VM.stopPrank();
    }

    function _swapOutAmt(
        DemoERC20V1 _token1,
        DemoERC20V1 _token2,
        uint256 _inAmt,
        uint8 _fee
    ) internal view returns (uint256) {
        uint256 grossAmt = _token2.balanceOf(address(_swap)) -
            FixedPointMathLib.divWadDown(
                FixedPointMathLib.mulWadDown(
                    _token1.balanceOf(address(_swap)),
                    _token2.balanceOf(address(_swap))
                ),
                _token1.balanceOf(address(_swap)) + _inAmt
            );
        uint256 g = 1e18 - _fee * 1e15;
        return FixedPointMathLib.mulWadDown(grossAmt, g);
    }
}
