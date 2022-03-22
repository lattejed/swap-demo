// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import {ERC20} from "solmate/tokens/ERC20.sol";

/// @title DemoFaucetV1
/// @author Matthew Wiriyathananon-Smith <m@lattejed.com>
/// @notice This is a dummy faucet we're going to use so we can distribute our
/// @notice dummy ERC20s to users for live testing of our demo.
/// @dev This is meant to be a learning exercise for the author. Do not use this in production.
contract DemoFaucetV1 {
    /// The `msg.sender` has already claimed max tokens
    error MaxTokensClaimed();

    uint256 constant TOKEN_CLAIM_AMT = 1e6;
    uint256 constant TOKEN_CLAIM_AMT_MAX = 1e18;

    ERC20 private _token;
    address payable private _owner;
    mapping(address => uint256) private _claimedTokens;

    constructor(ERC20 token_, address payable owner_) {
        _token = token_;
        _owner = owner_;
    }

    /// Allow any address to claim token up to MAX
    /// @notice If AMT isn't a multiple of MAX, allows claiming > MAX
    function claim() external {
        if (_claimedTokens[msg.sender] >= TOKEN_CLAIM_AMT_MAX) {
            revert MaxTokensClaimed();
        }
        _claimedTokens += TOKEN_CLAIM_AMT;
        // transfer
    }
}
