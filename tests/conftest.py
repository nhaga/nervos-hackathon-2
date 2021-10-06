#!/usr/bin/python3
import pytest
from brownie import interface
from web3 import Web3


@pytest.fixture(scope="function", autouse=True)
def isolate(fn_isolation):
    # perform a chain rewind after completing each test, to ensure proper isolation
    # https://eth-brownie.readthedocs.io/en/v1.10.3/tests-pytest-intro.html#isolation-fixtures
    pass


@pytest.fixture(scope="module")
def token(Token, accounts):
    return Token.deploy("Ether", "ckETH", 5000000000000000000, {"from": accounts[0]})


@pytest.fixture(scope="module")
def usdc(Token, accounts):
    return Token.deploy("USDC", "USDC", 5000000000000000000, {"from": accounts[0]})


@pytest.fixture(scope="module")
def asset(Asset, accounts, token, usdc):
    return Asset.deploy(token, usdc, {"from": accounts[0]})


@pytest.fixture(scope="module")
def trades(asset, Trades, accounts, usdc):
    strike = 3100
    year = 2021
    month = 12
    day = 15
    # return Trades.deploy(1312421, 3100, usdc, {"from": accounts[0]})
    asset.addOption(year, month, day, strike)
    usdc.approve(asset.activeOptionAddress(), Web3.toWei(500, "ether"))

    trades = interface.TradesInterface(asset.activeOptionAddress())
    return trades
