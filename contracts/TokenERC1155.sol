// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract GameItems is ERC1155, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;
    
    uint256 public constant NON_FUNGIBLE = 0;
    uint256 public constant FUNGIBLE = 1;
    uint256 public constant FUNGIBLE_LIMITED_100 = 2;

    uint256 public constant SHIFT = 3;
    uint256 public constant TYPE_MASK = 7;
    uint256 public constant ENTITY_MASK = 2040;

    uint256 public constant ENTITY1 = 0;
    uint256 public constant ENTITY2 = 1;
    uint256 public constant ENTITY3 = 2;

    mapping (uint256=>uint256) public entityTypes;

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        entityTypes[ENTITY1] = NON_FUNGIBLE;
        entityTypes[ENTITY2] = FUNGIBLE;
        entityTypes[ENTITY3] = FUNGIBLE_LIMITED_100;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mint(
        address to,
        uint256 entityId,
        uint256 amount
    ) external payable {
        require(amount > 0, "amount zero is not valid");
        require(
            (
                ((entityTypes[entityId] == NON_FUNGIBLE) && (amount == 1)) 
                || (entityTypes[entityId] == FUNGIBLE) 
                || ((entityTypes[entityId] == FUNGIBLE_LIMITED_100) && (amount <= 100))
            ), "token type is not correct" 
        );
        tokenIds.increment();
        uint256 newItemId = _buildIdTokenId(
            tokenIds.current(), 
            entityTypes[entityId], 
            entityId
        );
        _mint(to, newItemId, amount, "");
    }

    function getType (uint256 id) private pure returns (uint256) {
        return TYPE_MASK & id;
    }

    function getEntity (uint256 id) private pure returns (uint256) {
        return (ENTITY_MASK & id) >> 16;
    }

    function isNonFungible(uint256 id) public pure returns (bool) {
        return getType(id) == NON_FUNGIBLE;
    }

    function isFungible(uint256 id) public pure returns (bool) {
        return getType(id) == FUNGIBLE;
    }

    function isFungibleLimited(uint256 id) public pure returns (bool) {
        return getType(id) == FUNGIBLE_LIMITED_100;
    }

    function isEntity(uint256 id) public pure returns (bool) {
        uint256 entity = getEntity(id);
        return ((entity == ENTITY1) || (entity == ENTITY2) || (entity == ENTITY3));
    }

    function _buildIdTokenId(uint256 id, uint256 _type, uint256 _entity) 
    internal
    pure
    returns (uint256 tokenId)
    {

        uint256 newEntityItemId = (id << SHIFT) + _entity;
        return (newEntityItemId << SHIFT) + _type;
    }
}
