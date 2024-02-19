// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Pool} from "../src/Pool.sol";
import "../test/Constants.t.sol";
import "../test/MockERC20.t.sol";

// TO run on Anvil: forge script script/DeployPool.s.sol:DeployPool --fork-url http://localhost:8545 --broadcast
contract DeployPool is Script, Constants {
    function setUp() public {}

    function run() public {
        MockERC20 weth = new MockERC20("Wrapped Ether", "WETH", WETH_DECIMALS);
        Pool pool = new Pool(address(weth), "s Wrapped Ether", "s_WETH", WETH_DECIMALS, BPTS500);

        console2.log(address(pool));
    }
}
