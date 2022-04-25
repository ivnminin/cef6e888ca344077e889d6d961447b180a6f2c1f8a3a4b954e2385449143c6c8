// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract GameItems is ERC1155, AccessControl {
    uint256 private constant NON_FUNGIBLE = 0;
    uint256 private constant FUNGIBLE = 1;
    uint256 private constant FUNGIBLE_LIMITED = 2;

    uint256 private constant SHIFT = 3;
    uint256 private constant TYPE_MASK = 7;
    uint256 private constant ATTR_MASK = 56;
    uint256 private constant ID_MASK = 448;

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function isNonFungible(uint256 id) public pure returns (bool) {
        return (TYPE_MASK & id) == NON_FUNGIBLE;
    }

    function isFungible(uint256 id) public pure returns (bool) {
        return (TYPE_MASK & id) == FUNGIBLE;
    }

    function isFungibleLimited(uint256 id) public pure returns (bool) {
        return (TYPE_MASK & id) == FUNGIBLE_LIMITED;
    }
}
