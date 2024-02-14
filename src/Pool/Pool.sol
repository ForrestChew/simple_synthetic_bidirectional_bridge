// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Utils} from "../Utils.sol";

error OnlyBridgeRouter();

event BridgeNative(address bridger, address pool, uint256 amount, uint256 feeAmount, uint256 destinationId);

contract Pool is ERC20, Ownable {
    uint48 constant HUNDRED_PERCENT = 100_0000;

    uint8 immutable decimals_; 
    uint48 public protocolFee;
    address public immutable nativeAddress;
    address public bridgeRouterAddress;
    uint256 public amountbridged;

    struct NativeBridgeMessage {
        address sender;
        uint256 amount;
        uint256 destinationId;
    }

    modifier onlyBridgeRouter() {
        if (msg.sender != bridgeRouterAddress) revert OnlyBridgeRouter();
        _;
    }

    constructor(
        address _owner, 
        address _nativeAddress,
        address _bridgeRouterAddress,
        string memory _syntheticName, 
        string memory _syntheticSymbol,
        uint8 _decimals
    ) 
        ERC20(_syntheticName, _syntheticSymbol) Ownable(_owner) {
            decimals_ = _decimals;
            nativeAddress = _nativeAddress;
            bridgeRouterAddress = _bridgeRouterAddress;
        } 

    function bridgeNative(NativeBridgeMessage calldata _message) external onlyBridgeRouter {
        (uint256 amountReceived, uint256 protocolFeeAmount) = Utils.transferIn(
            nativeAddress,
            _message.sender,
            address(this),
            _message.amount,
            protocolFee
        );

        emit BridgeNative(
            _message.sender, 
            address(this), 
            amountReceived, 
            amountReceived - protocolFeeAmount,
            _message.destinationId
        );
    }

    function bridgeSynthetic() external {

    }

    /// @dev - Can only be called by offchain script when bridger locks native tokens on source.
    function mintSynthetic(uint256 _amount) external onlyOwner {

    }

    function _destroySynthetic(uint256 _amount) private {

    }

    function decimals() public view override returns (uint8) {
        return decimals_;
    }


}