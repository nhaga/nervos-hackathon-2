/* SPDX-License-Identifier: UNLICENSED */
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/token/ERC20/ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/token/ERC20/IERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/access/Ownable.sol";

interface OSTokenInterface is IERC20 {}

contract OSToken is ERC20, Ownable {
    constructor() ERC20("Ether", "ETH") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _transferOwnership(address newOwner) public onlyOwner {
        transferOwnership(newOwner);
    }

    function burn(uint256 amount, address _from) public {
        _burn(_from, amount);
    }
}
