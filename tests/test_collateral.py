from brownie import accounts


def test_deposit(accounts, trades):
    assert trades.deposit(100, {"from": accounts[0], "value": 100})


def test_balance(accounts, trades):
    trades.deposit(150, {"from": accounts[0], "value": 150})
    assert trades.getBalanceOf(accounts[0], {"from": accounts[0]}) == 150


def test_withdraw(accounts, trades):
    trades.deposit(150, {"from": accounts[0], "value": 150})
    assert trades.withdraw(50, {"from": accounts[0]})


def test_currency_deposit(accounts, trades, usdc):
    usdc.approve(trades, 500)
    assert trades.depositCurrency(10, {"from": accounts[0]})


def test_currency_balance(accounts, trades, usdc):
    usdc.approve(trades, 500)
    trades.depositCurrency(10, {"from": accounts[0]})
    assert trades.getCurrencyBalanceOf(accounts[0], {"from": accounts[0]}) == 10


def test_currency_deposit_from(accounts, trades, usdc):
    usdc.approve(trades, 500)
    usdc.transfer(accounts[1], 20)
    usdc.approve(trades, 100, {"from": accounts[1]})
    assert trades.depositCurrencyFrom(accounts[1], 10, {"from": accounts[0]})


def test_currency_withdraw(accounts, trades, usdc):
    usdc.approve(trades, 500)
    trades.depositCurrency(10, {"from": accounts[0]})
    assert trades.withdrawCurrency(5, {"from": accounts[0]})
    assert trades.withdrawCurrency(5, {"from": accounts[0]})
