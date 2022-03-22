// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import {DemoERC20V1} from "./DemoERC20V1.sol";

/// @title DemoFaucetV1
/// @author Matthew Wiriyathananon-Smith <m@lattejed.com>
/// @notice This is a dummy faucet we're going to use so we can distribute our
/// @notice dummy ERC20s to users for live testing of our demo.
/// @dev This is meant to be a learning exercise for the author. Do not use this in production.
contract DemoFaucetV1 {
    /// The `msg.sender` already claimed >= MAX tokens
    error MaxTokensClaimed();

    uint256 private constant _CLAIM_AMOUNT = 100 * 1e18;
    uint256 private constant _CLAIM_AMOUNT_MAX = 1000 * 1e18;

    DemoERC20V1 private _token;
    mapping(address => uint256) private _claimedAmounts;

    constructor(DemoERC20V1 token_) {
        _token = token_;
    }

    /// Allow any address to claim tokens up to MAX
    /// @dev This assumes that MAX is a multiple of AMT. If not, total claimable will be > MAX.
    function claim() external {
        if (_claimedAmounts[msg.sender] >= _CLAIM_AMOUNT_MAX) {
            revert MaxTokensClaimed();
        }
        _claimedAmounts[msg.sender] += _CLAIM_AMOUNT;
        // We will ignore the return value since this will revert on error
        _token.transfer(msg.sender, _CLAIM_AMOUNT);
    }
}
