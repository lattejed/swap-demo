// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoERC20V1} from "./DemoERC20V1.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";

// FIXME: Remove this
import {DSTestPlus} from "./test/utils/DSTestPlus.sol";

/// TODO:
contract DemoPoolV1 is DSTestPlus {
    DemoERC20V1 internal immutable _tokenA;
    DemoERC20V1 internal immutable _tokenB;
    uint256 internal _k;
    uint256 internal _g;

    DemoERC20V1 public lpToken;

    /// TODO:
    /// @param _fee in tenths of a percent, e.g., 3 = 0.3%
    constructor(
        DemoERC20V1 tokenA_,
        DemoERC20V1 tokenB_,
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint8 _fee
    ) {
        _tokenA = tokenA_;
        _tokenB = tokenB_;
        lpToken = new DemoERC20V1(
            _name,
            _symbol,
            _decimals,
            payable(address(this))
        );
        _g = 1e18 - _fee * 1e15;
    }

    /// Deposit tokens in a pair and receive LP tokens
    /// @notice This of course requires `ERC20.approve` to have been called previously
    /// for AMT >= deposit AMT
    /// @param _tokenAAmt amount of first token to deposit
    /// @param _tokenAAmt amount of second token to deposit
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
