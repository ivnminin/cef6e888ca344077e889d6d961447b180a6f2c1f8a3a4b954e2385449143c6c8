// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGameItem {
    function awardItem(address player, string memory tokenURI) 
        external
        payable
        returns (uint256);
}
