// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../TokenERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MockGameItems is GameItems{
    using Counters for Counters.Counter;

    constructor() GameItems() {}

    function getCurrentTokenId(uint256 _entity) 
    external 
    view 
    returns(uint256) {
        uint256 currentId = tokenIds.current();
        return _buildIdTokenId(currentId, entityTypes[_entity], _entity);
    }
}
