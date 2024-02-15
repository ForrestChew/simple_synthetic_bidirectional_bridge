// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import "./interfaces/IERC20.sol";

library Utils {
    uint48 constant HUNDRED_PERCENT = 100_0000;

    function transferIn(
        address _token, 
        address _from, 
        address _to, 
        uint256 _amount, 
        uint48 _fee
        ) external returns (uint256 amountReceived, uint256 protocolFeeAmount) {
            IERC20 token = IERC20(_token);
            uint256 initialBalance = token.balanceOf(_to);
            token.transferFrom(_from, _to, _amount);
            
            amountReceived = token.balanceOf(_to) - initialBalance;
            protocolFeeAmount = amountReceived * _fee / HUNDRED_PERCENT;
    }

    function transferOut(
        address _token, 
        address _to, 
        uint256 _amount
        ) external {
            IERC20 token = IERC20(_token);
            token.transfer(_to, _amount);
    }
}