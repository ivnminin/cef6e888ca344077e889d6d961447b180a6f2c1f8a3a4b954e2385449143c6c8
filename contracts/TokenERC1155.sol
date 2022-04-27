// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract GameItems is ERC1155, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    uint256 private constant NON_FUNGIBLE = 0;
    uint256 private constant FUNGIBLE = 1;
    uint256 private constant FUNGIBLE_LIMITED_100 = 2;

    uint256 private constant SHIFT = 3;
    uint256 private constant TYPE_MASK = 7;
    uint256 private constant ATTR_MASK = 56;

    uint256 private constant NON_FUNGIBLE_ATTR1 = 0;
    uint256 private constant FUNGIBLE_ATTR1 = 1;
    uint256 private constant FUNGIBLE_LIMITED_100_ATTR1 = 2;

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mint(
        address to,
        uint256 _type,
        uint _attr,
        uint256 amount
    ) external payable {
        require(amount > 0);
        require(
            (
                ((_type == NON_FUNGIBLE) && (amount == 1)) 
                || (_type == FUNGIBLE) 
                || ((_type == FUNGIBLE_LIMITED_100) && (amount <= 100))
            ) 
        );
        require(
            ((_attr == NON_FUNGIBLE_ATTR1) && (_type == NON_FUNGIBLE))
            || ((_attr == FUNGIBLE_ATTR1) && (_type == NON_FUNGIBLE))
            || ((_attr == FUNGIBLE_LIMITED_100_ATTR1) && (_type == FUNGIBLE_LIMITED_100))
        );
        uint256 newItemId = _buildIdToken(_type, _attr);
        _mint(to, newItemId, amount, "");
    }

    function isNonFungible(uint256 id) public pure returns (bool) {
        return (TYPE_MASK & id) == NON_FUNGIBLE;
    }

    function isFungible(uint256 id) public pure returns (bool) {
        return (TYPE_MASK & id) == FUNGIBLE;
    }

    function isFungibleLimited(uint256 id) public pure returns (bool) {
        return (TYPE_MASK & id) == FUNGIBLE_LIMITED_100;
    }

    function isNonFungibleAttr1(uint256 id) public pure returns (bool) {
        return ((ATTR_MASK & id) >> SHIFT) == NON_FUNGIBLE_ATTR1;
    }

    function isFungibleAttr1(uint256 id) public pure returns (bool) {
        return ((ATTR_MASK & id) >> SHIFT) == FUNGIBLE_ATTR1;
    }

    function isFungibleLimitedAttr1(uint256 id) public pure returns (bool) {
        return (((ATTR_MASK & id)) >> SHIFT) == FUNGIBLE_LIMITED_100_ATTR1;
    }

    function _buildIdToken(uint256 _type, uint256 _attr) private returns (uint256 tokenId){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        uint256 newItemIdAttr = (newItemId << SHIFT) +_attr;
        return (newItemIdAttr << SHIFT) + _type;
    }
}
