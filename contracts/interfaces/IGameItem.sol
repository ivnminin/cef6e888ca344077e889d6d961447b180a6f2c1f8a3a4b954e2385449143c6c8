// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGameItem {
    function getPrice() external view returns (uint256);
    function awardItem(address player
    ) 
        external
        payable
        returns (uint256);
}
