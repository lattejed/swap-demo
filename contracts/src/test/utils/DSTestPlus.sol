// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.10 <0.9.0;

import {DSTest} from "@ds-test/test.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {stdCheats, stdError} from "@forge-std/stdlib.sol";
import {Vm} from "@forge-std/Vm.sol";

contract DSTestPlus is DSTest, stdCheats {
    bytes public constant ERROR_NULL = bytes("");
    bytes public constant ERROR_ASSERT =
        abi.encodeWithSignature("Panic(uint256)", 0x01);
    bytes public constant ERROR_UNDER_OVERFLOW =
        abi.encodeWithSignature("Panic(uint256)", 0x11);
    bytes public constant ERROR_DIV_BY_0 =
        abi.encodeWithSignature("Panic(uint256)", 0x12);
    bytes public constant ERROR_POP_EMPTY_ARRAY =
        abi.encodeWithSignature("Panic(uint256)", 0x31);
    bytes public constant ERROR_INDEX_OOB =
        abi.encodeWithSignature("Panic(uint256)", 0x32);

    /// @dev Use forge-std Vm logic
    Vm public constant VM = Vm(HEVM_ADDRESS);

    function _assertERC20Eq(ERC20 erc1, ERC20 erc2) internal {
        assertEq(address(erc1), address(erc2));
    }
}
