// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./interfaces/IGLDToken.sol";

contract GameItem is ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;

    IGLDToken public tokenGLD;
    string public baseURI = "https://game.example/api/item/";
    bytes32 public constant BUYER_ROLE = keccak256("BUYER_ROLE");
    Counters.Counter private _tokenIds;
    uint256 public price;

    constructor(address _token, uint256 _price) ERC721("GameItem", "ITM") {
        tokenGLD = IGLDToken(_token);
        price = _price;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function awardItem(address player)
        public
        onlyRole(BUYER_ROLE)
        returns (uint256)
    {   
        require(tokenGLD.balanceOf(msg.sender) >= price, "not enough balance");
        
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, Strings.toString(newItemId));
        tokenGLD.transferFrom(msg.sender, address(this), price);
        return newItemId;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    function getPrice() external view returns (uint256) {
        return price;
    }
}
