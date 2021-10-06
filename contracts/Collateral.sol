// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/token/ERC20/IERC20.sol";

contract Collateral {
    address public currencyAddress;

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public currencyBalanceOf;
    mapping(address => uint256) public escrowBalanceOf;

    function getBalanceOf(address _account) public view returns (uint256) {
        return balanceOf[_account];
    }

    function getCurrencyBalanceOf(address _account)
        public
        view
        returns (uint256)
    {
        return currencyBalanceOf[_account];
    }

    function getEscrowBalanceOf(address _account)
        public
        view
        returns (uint256)
    {
        return escrowBalanceOf[_account];
    }

    function deposit(uint256 amount) public payable {
        require(msg.value == amount);
        require(amount > 0);
        balanceOf[msg.sender] += amount;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balanceOf[msg.sender]);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function depositCurrency(uint256 amount) public payable {
        require(amount > 0);
        IERC20(currencyAddress).transferFrom(msg.sender, address(this), amount);
        currencyBalanceOf[msg.sender] += amount;
    }

    function withdrawCurrency(uint256 amount) public payable {
        require(amount > 0);
        require(currencyBalanceOf[msg.sender] >= amount);
        currencyBalanceOf[msg.sender] -= amount;
        IERC20(currencyAddress).transfer(msg.sender, amount);
    }

    function depositCurrencyFrom(address _from, uint256 amount) public payable {
        require(amount > 0);
        IERC20(currencyAddress).transferFrom(_from, address(this), amount);
        currencyBalanceOf[_from] += amount;
    }

    function withdrawCurrencyFrom(address _from, uint256 amount)
        public
        payable
    {
        require(amount > 0);
        require(currencyBalanceOf[_from] >= amount);
        currencyBalanceOf[_from] -= amount;
        IERC20(currencyAddress).transfer(_from, amount);
    }

    function depositEscrowFrom(address _from, uint256 amount) public payable {
        require(amount > 0);
        IERC20(currencyAddress).transferFrom(_from, address(this), amount);
        escrowBalanceOf[_from] += amount;
    }

    function withdrawEscrowFrom(address _from, uint256 amount) public payable {
        require(amount > 0);
        require(escrowBalanceOf[_from] >= amount);
        escrowBalanceOf[_from] -= amount;
        IERC20(currencyAddress).transfer(_from, amount);
    }

    function transferEscrowTo(
        address _from,
        address _to,
        uint256 amount
    ) public payable {
        require(amount > 0);
        require(escrowBalanceOf[_from] >= amount);
        escrowBalanceOf[_from] -= amount;
        IERC20(currencyAddress).transferFrom(_from, _to, amount);
    }

    function transferCurrencyTo(
        address _from,
        address _to,
        uint256 amount
    ) public payable {
        require(amount > 0);
        require(currencyBalanceOf[_from] >= amount);
        currencyBalanceOf[_from] -= amount;
        IERC20(currencyAddress).transferFrom(_from, _to, amount);
    }

    function transferTo(
        address _from,
        address _to,
        uint256 amount
    ) public payable {
        require(amount > 0);
        IERC20(currencyAddress).transferFrom(_from, _to, amount);
    }

    function getCollateral(address _trader) public view returns (uint256) {
        return currencyBalanceOf[_trader];
    }
}
