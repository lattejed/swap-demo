// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoSwapV1} from "../DemoSwapV1.sol";

contract DemoSwapV1Test is DSTestPlus {
    DemoSwapV1 private _demoSwap;

    function setUp() public {
        _demoSwap = new DemoSwapV1();
    }
}
