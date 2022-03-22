// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {DemoERC20V1} from "../DemoERC20V1.sol";
import {DemoFaucetV1} from "../DemoFaucetV1.sol";

contract DemoFaucetV1Test is DSTestPlus {
    address payable private _owner;
    address payable private _user;
    DemoERC20V1 private _token;
    DemoFaucetV1 private _faucet;

    function setUp() public {
        _owner = payable(vm.addr(0xCA55E77E));
        _user = payable(vm.addr(0xDECAFBAD));
        _token = new DemoERC20V1("Token", "TOK", 18, _owner, type(uint256).max);
        _faucet = new DemoFaucetV1(_token, _owner);
    }

    function testClaim() public {
        vm.prank(_user);
        _faucet.claim();
        assertEq(_token.balanceOf(address(_user)), 100 * 1e18);
    }

    //    function testBadMint() public {
    //        vm.expectRevert(DemoERC20V1.InvalidSenderAddress.selector);
    //        _token.mint(address(_owner), 1e18);
    //    }
}
