// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGameItems {
    function mint(
        address to,
        uint256 entityId,
        uint256 amount
    ) external payable;
}
