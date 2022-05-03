// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IGLDToken.sol";
import "./interfaces/IGameItem.sol";
import "./interfaces/IGameItems.sol";

contract Market {
    IGLDToken public tokenGLD;
    IGameItem public tokenGameItem;
    IGameItems public tokenGameItems;

    constructor (
        address tokenERC20, 
        address tokenERC721, 
        address tokenERC1155
    ) {
        tokenGLD = IGLDToken(tokenERC20);
        tokenGameItem = IGameItem(tokenERC721);
        tokenGameItems = IGameItems(tokenERC1155);
    }

    function swapETHtoTokenGLD() external payable {
        tokenGLD.deposit{value: msg.value}();
    }

    function swapTokenGLDtoETH(uint256 amount) external {
        tokenGLD.withdraw(amount);
    }

    function buyTokenGameItem() external payable {
        uint256 _price = tokenGameItem.getPrice();
        tokenGLD.transferFrom(msg.sender, address(this), _price);
        tokenGLD.approve(address(tokenGameItem), _price);
        tokenGameItem.awardItem(msg.sender);
    }

    function buyTokenGameItems(
        address to, 
        uint256 entityId, 
        uint256 amount
    ) external payable {
        tokenGameItems.mint{value: msg.value}(to, entityId, amount);
    }
}