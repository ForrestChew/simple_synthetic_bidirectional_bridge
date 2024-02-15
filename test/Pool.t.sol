// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Pool} from "../src/Pool.sol";
import {MockERC20} from "./MockERC20.t.sol";
import "./Constants.t.sol";

contract PoolTest is Test, Constants {
    Pool pool;
    MockERC20 weth;

    function setUp() public {
        weth = new MockERC20("Wrapped Ether", "WETH", WETH_DECIMALS);
        pool = new Pool(address(weth), "s Wrapped Ether", "s_WETH", WETH_DECIMALS, BPTS500);
    }

    function testDeployBridgePool() public {
        assertEq(pool.amountBridged(), ZERO);
        assertEq(pool.feesCollected(), ZERO);
        assertEq(pool.protocolFee(), BPTS500);
        assertEq(pool.nativeAddress(), address(weth));
    }

    function testBridgeNativeToken() public {
        startHoax(USER_A);
        uint256 protocolFeeAmount = _calculateProtocolFees(
            WETH_1,
            BPTS500 
        );
        weth.mint(USER_A, WETH_1);
        weth.approve(address(pool), WETH_1);

        assertEq(weth.balanceOf(USER_A), WETH_1);
        assertEq(weth.allowance(USER_A, address(pool)), WETH_1);

        Pool.NativeBridgeMessage memory bridgeData = _buildNativeBridgeMessage(
            USER_A,
            WETH_1,
            ARBITRUM_ONE
        );

        pool.bridgeNative(bridgeData);

        // User Changes
        assertEq(weth.balanceOf(USER_A), ZERO);
        assertEq(weth.allowance(USER_A, address(pool)), ZERO);
        
        // Pool Changes
        assertEq(weth.balanceOf(address(pool)), WETH_1);
        assertEq(weth.balanceOf(address(pool)), WETH_1);
        assertEq(pool.amountBridged(), WETH_1 - protocolFeeAmount);
        assertEq(pool.feesCollected(), protocolFeeAmount);
    }

    function _buildNativeBridgeMessage(
            address _sender,
            uint256 _amount, 
            uint256 _destinationId
        ) private pure returns (Pool.NativeBridgeMessage memory) {
        return Pool.NativeBridgeMessage({
                sender: _sender,
                amount: _amount,
                destinationId: _destinationId
            });
    }

    function _calculateProtocolFees(
            uint256 _amountBridged, 
            uint48 _fee
        ) public pure returns (uint256 protocolFeeAmount) {
       protocolFeeAmount = _amountBridged * _fee / 100_0000; 
    }

}