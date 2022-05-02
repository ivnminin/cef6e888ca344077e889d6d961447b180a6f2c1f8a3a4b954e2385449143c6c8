// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";import "@openzeppelin/contracts/access/AccessControl.sol";


import "./interfaces/IGLDToken.sol";

contract GameItem is ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    IGLDToken public tokenGLD;
    string public baseURI = "https://game.example/api/item/";

    bytes32 public constant BUYER_ROLE = keccak256("BUYER_ROLE");

    constructor(address _token) ERC721("GameItem", "ITM") {
        tokenGLD = IGLDToken(_token);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function awardItem(address player)
        public
        payable
        onlyRole(BUYER_ROLE)
        returns (uint256)
    {   
        require(tokenGLD.balanceOf(tx.origin) >= msg.value, "not enough balance");
        
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, Strings.toString(newItemId));

        return newItemId;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
