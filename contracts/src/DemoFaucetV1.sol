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

    uint256 constant _CLAIM_AMOUNT = 1e6;
    uint256 constant _CLAIM_AMOUNT_MAX = 1e18;

    ERC20 private _token;
    address payable private _owner;
    mapping(address => bool) private _approvedAddresses;

    constructor(ERC20 token_, address payable owner_) {
        _token = token_;
        _owner = owner_;
    }

    /// Allow any address to claim tokens up to MAX
    /// @dev This assumes that AMT is a multiple of MAX. If not, total claimable will be < MAX.
    function claim() external {
        if (_approvedAddresses[msg.sender] == false) {
            _approvedAddresses[msg.sender] = true;
            _token.approve(msg.sender, _CLAIM_AMOUNT_MAX);
        }
        // We will ignore the return value since this will revert if allowance < AMT
        _token.transferFrom(_owner, msg.sender, _CLAIM_AMOUNT);
    }
}
