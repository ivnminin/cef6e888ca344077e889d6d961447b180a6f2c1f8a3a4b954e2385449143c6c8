// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    event  Deposit(address indexed dst, uint amount);
    event  Withdrawal(address indexed src, uint amount);

    constructor() ERC20("Gold", "GLD") {}

    function deposit () external payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw (uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "not enough balance");
        _burn(msg.sender, amount);
        address payable receiver = payable(msg.sender);
        (bool sent, ) = receiver.call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit Withdrawal(receiver, amount);
    }
}
