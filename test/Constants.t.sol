// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

abstract contract Constants {
    // Utility
    uint8 constant ZERO = 0;
    uint8 constant ONE = 1;

    // Token Decimals
    uint8 constant WETH_DECIMALS = 18;

    uint48 constant BPTS500 = 50000; // 5%

    // Token Amounts
    uint256 WETH_1 = 1 * 10 ** WETH_DECIMALS;

    // Chain IDs
    uint256 ARBITRUM_ONE = 42161;

    // Protocol Participants
    address constant USER_A = address(1); 
}