// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import { ERC20 } from "solmate/tokens/ERC20.sol";

/// @title DemoERC20V1
/// @author Matthew Wiriyathananon-Smith <m@lattejed.com>
/// @notice This is a dummy ERC20 we're going to use for our demo so we don't have
/// @notice to rely on existing tokens on whatever testnet(s) we're using.
/// @dev This is meant to be a learning exercise for the author. Do not use this in production.
contract DemoERC20V1 is ERC20 {
  address payable private _owner;

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    address payable owner_
  ) ERC20(_name, _symbol, _decimals) {
    _owner = owner_;
  }

  function mint(address to, uint256 value) public virtual {
    require(msg.sender == _owner);
    _mint(to, value);
  }
}
