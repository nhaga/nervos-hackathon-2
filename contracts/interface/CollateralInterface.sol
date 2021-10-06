// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface CollateralInterface {
    function depositCurrency(uint256 amount) external payable;

    function withdrawCurrency(uint256 amount) external payable;

    function depositCurrencyFrom(address _from, uint256 amount)
        external
        payable;

    function withdrawCurrencyFrom(address _from, uint256 amount)
        external
        payable;

    function depositEscrowFrom(address _from, uint256 amount) external payable;

    function withdrawEscrowFrom(address _from, uint256 amount) external payable;

    function transferEscrowTo(
        address _from,
        address _to,
        uint256 amount
    ) external payable;

    function transferTo(
        address _from,
        address _to,
        uint256 amount
    ) external payable;

    function getCollateral(address _trader) external returns (uint256);
}
