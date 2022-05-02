// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGameItem {
    function awardItem(address player
    ) 
        external
        payable
        returns (uint256);
}
