// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GameItem is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public baseURI = "https://game.example/api/item/";

    address private owner;

    modifier onlyOwner(){
        require(msg.sender == owner, "You`re not an owner!");
        _;
    }

    constructor() ERC721("GameItem", "ITM") {
        owner = msg.sender;
    }

    function awardItem(address player)
        public
        payable
        onlyOwner
        returns (uint256)
    {
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
