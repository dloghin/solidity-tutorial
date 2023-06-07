// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC20 is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("My SGD Coin", "SGD5") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** 18);
    }
}
