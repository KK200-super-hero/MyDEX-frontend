// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FeeCollector {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw(IERC20 token) external {
        require(msg.sender == owner, "Not owner");
        uint balance = token.balanceOf(address(this));
        require(balance > 0, "No funds");
        token.transfer(owner, balance);
    }
}