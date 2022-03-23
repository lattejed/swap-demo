// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DemoERC20V1} from "./DemoERC20V1.sol";

/// The `msg.sender` did not have enough TOK for tx
error InsufficientTokens(string _symbol);

/// @title DemoSwapV1
/// @author Matthew Wiriyathananon-Smith <m@lattejed.com>
/// @notice This is a contract similar to Uniswap V1 developed from first principles.
/// It is not an attempt to recreate Uniswap V1 in its entirety or guess what
/// the actual implementation looks like. This is meant to work for the stated
/// purpose while being 1) correct and 2) secure. This contains no gas optimizations.
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

    /// Deposit token pair and receive LP tokens
    /// @notice This of course requires `ERC20.approve` to have been called previously
    /// for AMT >= deposit AMT
    function deposit(uint256 _tokenAAmt, uint256 _tokenBAmt) external {
        _tokenA.transferFrom(msg.sender, address(this), _tokenAAmt);
        _tokenB.transferFrom(msg.sender, address(this), _tokenBAmt);
    }
}
