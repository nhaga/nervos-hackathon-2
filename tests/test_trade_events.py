import pytest
from brownie import accounts, interface


def test_trades(trades, usdc):
    usdc.approve(trades, 5000)

    tx1 = trades.enterOrder(1, 20, 2, {"from": accounts[0]})

    assert len(tx1.events) == 4

    # assert tx1.events[0][] == 1
