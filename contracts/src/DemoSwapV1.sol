// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoPoolV1} from "./DemoPoolV1.sol";
import {DemoERC20V1} from "./DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

/// The swap from and swap to tokens were invalid
error InvalidTokenPair();

/// @title DemoSwapV1
/// @author Matthew Wiriyathananon-Smith <m@lattejed.com>
/// @notice This is a contract similar to Uniswap V1 developed from first principles.
/// It is not an attempt to recreate Uniswap V1 in its entirety or guess what
/// the actual implementation looks like. This is meant to work for the stated
/// purpose while being 1) correct and 2) secure. This contains no gas optimizations.
///
/// This main source for this is https://web.stanford.edu/~guillean/papers/uniswap_analysis.pdf
/// and https://www.machow.ski/posts/an_introduction_to_automated_market_makers/ along with
/// various other blog posts about CPMMs.
///
/// @dev This is meant to be a learning exercise for the author. Do not use this in production.
contract DemoSwapV1 is DemoPoolV1 {
    modifier validTokenPair(address _from, address _to) {
        if (
            !(_from == address(_tokenA) && _to == address(_tokenB)) &&
            !(_from == address(_tokenB) && _to == address(_tokenA))
        ) {
            revert InvalidTokenPair();
        }
        _;
    }

    /// TODO:
    /// @param _fee in tenths of a percent, e.g., 3 = 0.3%
    constructor(
        DemoERC20V1 _tokenA,
        DemoERC20V1 _tokenB,
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint8 _fee
    ) DemoPoolV1(_tokenA, _tokenB, _name, _symbol, _decimals, _fee) {}

    /// Swap
    /// @param _amount of token to swap
    // TODO: These will accept a swap when the pool is empty which results
    // in an infinite price.
    function swap(
        address _from,
        address _to,
        uint256 _amount
    ) external validTokenPair(_from, _to) {
        DemoERC20V1 fromToken = DemoERC20V1(_from);
        DemoERC20V1 toToken = DemoERC20V1(_to);
        uint256 outAmt = _tokenToAmt(fromToken, toToken, _amount);
        fromToken.transferFrom(msg.sender, address(this), _amount);
        toToken.transfer(msg.sender, outAmt);
    }

    function swapEstimate(
        address _from,
        address _to,
        uint256 _amount
    ) external view validTokenPair(_from, _to) returns (uint256) {
        return _tokenToAmt(DemoERC20V1(_from), DemoERC20V1(_to), _amount);
    }

    function _tokenToAmt(
        DemoERC20V1 _fromToken,
        DemoERC20V1 _toToken,
        uint256 _amount
    ) private view returns (uint256) {
        uint256 newFromAmt = _fromToken.balanceOf(address(this)) + _amount;
        uint256 netAmt = _toToken.balanceOf(address(this)) -
            FixedPointMathLib.divWadUp(_k, newFromAmt);
        return FixedPointMathLib.mulWadUp(netAmt, _g);
    }
}
