// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGLDToken {
    function deposit() external payable;
    function transferFrom(address src, address dst, uint amount) external returns (bool);
    function withdraw(uint amount) external;
    function balanceOf(address account) external returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}
