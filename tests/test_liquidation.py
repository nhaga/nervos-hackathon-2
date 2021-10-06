from web3 import Web3
from brownie import accounts


def toWei(x):
    return Web3.toWei(x, "ether")


def test_enter_trade0(trades, usdc):
    usdc.approve(trades, 500)
    trades.enterOrder(1, 3, 2, {"from": accounts[0]})
    trades.enterOrder(1, 2, 2, {"from": accounts[0]})
    assert len(trades.getTrades()) == 2


def test_enter_trade(trades, usdc):
    usdc.mint(accounts[0], toWei(500))
    usdc.approve(trades, toWei(500), {"from": accounts[0]})
    trades.enterOrder(1, toWei(3), 2, {"from": accounts[0]})
    trades.enterOrder(1, toWei(3), 2, {"from": accounts[0]})
    assert len(trades.getTrades()) == 2


def test_list_liquidation(trades, usdc):
    usdc.mint(accounts[0], toWei(100000))
    usdc.mint(accounts[1], toWei(100000))
    usdc.approve(trades, toWei(5000), {"from": accounts[0]})
    usdc.approve(trades, toWei(5000), {"from": accounts[1]})
    usdc.mint(accounts[1], toWei(100000))

    trades.enterOrder(1, toWei(3), 5, {"from": accounts[1]})
    trades.enterOrder(2, toWei(4), 5, {"from": accounts[0]})
    """
    trades.enterOrder(1, 5, 5, {"from": accounts[0]})
    trades.enterOrder(1, 5, 50, {"from": accounts[0]})

    trades.enterOrder(2, 3, 5, {"from": accounts[1]})

    trades.enterOrder(2, toWei(3), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.25), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.5), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.75), 50, {"from": accounts[1]})
    """

    assert len(trades.getTradersForLiquidation(3000)) == 0
