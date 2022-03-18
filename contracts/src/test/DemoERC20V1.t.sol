// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import { DSTestPlus } from "./utils/DSTestPlus.sol";
import { DemoERC20V1 } from "../DemoERC20V1.sol";

contract DemoERC20V1Test is DSTestPlus {
  DemoERC20V1 private _token;

  function setUp() public {
    _token = new DemoERC20V1("Token", "TOK", 18);
  }

  function testInvariantMetadata() public {
    assertEq(_token.name(), "Token");
    assertEq(_token.symbol(), "TOK");
    assertEq(_token.decimals(), 18);
  }
}
