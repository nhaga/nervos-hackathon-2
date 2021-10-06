import pytest
from web3 import Web3
from brownie import accounts, interface


def test_trades(trades):
    assert len(trades.getTrades()) == 0


def test_enter_trade(trades, usdc):
    usdc.approve(trades, 500)
    trades.enterOrder(1, 3, 2, {"from": accounts[0]})
    trades.enterOrder(1, 2, 2, {"from": accounts[0]})
    assert len(trades.getTrades()) == 2


def test_escrow(trades, usdc):
    usdc.approve(trades, 500)
    usdc.mint(accounts[0], 1000000000)

    trades.enterOrder(1, 3, 2, {"from": accounts[0]})
    assert trades.getEscrowBalanceOf(accounts[0]) == 6


def test_cancel_order(trades, usdc):
    usdc.approve(trades, 500)
    usdc.mint(accounts[0], 1000000000)

    trades.enterOrder(1, 3, 2, {"from": accounts[0]})
    assert trades.getEscrowBalanceOf(accounts[0]) == 6
    trades.cancelOrder(0, {"from": accounts[0]})
    assert trades.getOrderbook()[-1][-1] == 2
    assert trades.getEscrowBalanceOf(accounts[0]) == 0


def test_execution(trades, usdc):
    usdc.approve(trades, 5000)

    trades.enterOrder(1, 30, 2, {"from": accounts[0]})
    trades.enterOrder(2, 20, 2, {"from": accounts[0]})
    """
    oltoken = interface.OLTokenInterface(trades.longTokenAddress({"from": accounts[0]}))
    assert oltoken.balanceOf(accounts[0]) == 2

    ostoken = interface.OSTokenInterface(trades.shortTokenContract())
    assert ostoken.balanceOf(accounts[0]) == 2
    """
