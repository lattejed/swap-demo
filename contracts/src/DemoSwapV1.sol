// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoERC20V1} from "./DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

// FIXME: Remove this
import {DSTestPlus} from "./test/utils/DSTestPlus.sol";

// /// The `msg.sender` did not have tokens for call
// error InsufficientBalance();

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
contract DemoSwapV1 is DSTestPlus {
    DemoERC20V1 private _tokenA;
    DemoERC20V1 private _tokenB;
    uint256 private _k;

    DemoERC20V1 public lpToken;

    constructor(
        DemoERC20V1 tokenA_,
        DemoERC20V1 tokenB_,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        _tokenA = tokenA_;
        _tokenB = tokenB_;
        lpToken = new DemoERC20V1(
            _name,
            _symbol,
            _decimals,
            payable(address(this))
        );
    }

    function swap(address _token, uint256 _amount) external {
        DemoERC20V1 token1;
        DemoERC20V1 token2;
        if (_token == address(_tokenA)) {
            token1 = _tokenA;
            token2 = _tokenB;
        }
        if (_token == address(_tokenB)) {
            token1 = _tokenB;
            token2 = _tokenA;
        }
        /// This will fail if given an invalid token address
        token1.transferFrom(msg.sender, address(this), _amount);
        uint256 token2Amt = token2.balanceOf(address(this)) -
            FixedPointMathLib.divWadUp(_k, token1.balanceOf(address(this)));
        token2.transfer(msg.sender, token2Amt);
    }

    /// Deposit tokens in a pair and receive LP tokens
    /// @notice This of course requires `ERC20.approve` to have been called previously
    /// for AMT >= deposit AMT
    function deposit(uint256 _tokenAAmt, uint256 _tokenBAmt) external {
        /// We're not going to do any value checking here because
        /// - The client should deal with providing correct amounts
        /// - There's nothing malicious that can be done here, apart from
        ///   throwing an error or throwing money away
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

        /// Mint LP tokens
        lpToken.mint(msg.sender, tokenLPAmt);

        /// Update k
        _k = FixedPointMathLib.mulWadUp(
            _tokenA.balanceOf(address(this)),
            _tokenB.balanceOf(address(this))
        );
    }

    /// Burn LP tokens and receive a proportionate share of the token pool
    function withdraw(uint256 _tokenLPAmt) external {
        /// We won't check this. If `_tokenLPAmt` is greater than the sender's
        /// balance the call will revert when `burn` is called
        uint256 share = FixedPointMathLib.divWadUp(
            lpToken.totalSupply(),
            _tokenLPAmt
        );

        /// Burn any valid amount the sender is holding
        lpToken.burn(msg.sender, _tokenLPAmt);

        /// Transfer share of pool to sender
        _tokenA.transfer(
            msg.sender,
            FixedPointMathLib.mulWadUp(_tokenA.balanceOf(address(this)), share)
        );
        _tokenB.transfer(
            msg.sender,
            FixedPointMathLib.mulWadUp(_tokenB.balanceOf(address(this)), share)
        );

        /// We're calling `transfer` on a trusted contract, so we can ignore
        /// the potential for reentrancy here.
        // solhint-disable-next-line reentrancy
        _k = FixedPointMathLib.mulWadUp(
            _tokenA.balanceOf(address(this)),
            _tokenB.balanceOf(address(this))
        );
    }
}
