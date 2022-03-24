// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoERC20V1} from "./DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

// /// The `msg.sender` did not have enough TOK for tx
// error InsufficientTokens(string _symbol);

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
contract DemoSwapV1 {
    DemoERC20V1 private _tokenA;
    DemoERC20V1 private _tokenB;
    DemoERC20V1 private _tokenLP;
    uint256 private _k;

    constructor(DemoERC20V1 tokenA_, DemoERC20V1 tokenB_) {
        _tokenA = tokenA_;
        _tokenB = tokenB_;
    }

    /// Deposit tokens in a pair and receive LP tokens
    /// @notice This of course requires `ERC20.approve` to have been called previously
    /// for AMT >= deposit AMT
    function deposit(uint256 _tokenAAmt, uint256 _tokenBAmt) external {
        /// We're not going to do any value checking here because
        /// - The client should deal with providing correct amounts
        /// - There's nothing malicious that can be done here, apart from
        ///   throwing money away as an arb opportunity
        _tokenA.transferFrom(msg.sender, address(this), _tokenAAmt);
        _tokenB.transferFrom(msg.sender, address(this), _tokenBAmt);

        /// Full disclosure: I picked up reading about CPMMs that LP tokens are (always?)
        /// calculated by taking the geometric mean of the deposited tokens. While simming
        /// it shows that it works, despite token imbalances, I don't know why it's correct
        /// or what the intuition for it is.
        ///
        /// The only thing that makes a geometric mean unique mathematically is that
        /// gm(x/y) == gm(x)/gm(y) which means a geometric mean is correct when averaging
        /// normalized results.
        ///
        /// The above also holds for gm(x*y) == gm(x)*gm(y)
        ///
        /// We can probably just use a product here with the same results. Or possibly
        /// another type of average.

        // TODO: Test different methods for calculating `tokenLPAmt` and figure out if
        // geometric mean is the only correct way
        uint256 tokenLPAmt = FixedPointMathLib.sqrt(_tokenAAmt * _tokenBAmt);
    }
}
