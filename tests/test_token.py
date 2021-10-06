import web3

toWei = web3.Web3.toWei


def test_name(token):
    assert token.name() == 'Ether'


def test_symbol(token):
    assert token.symbol() == 'ckETH'


def test_initial_supply(token):
    assert token.totalSupply() == 5000000000000000000


"""
def test_balance(accounts, token):
    token.mint(accounts[1], 100, {'from': accounts[0]})
    assert token.balanceOf(accounts[1]) == 100


def test_sender_balance_decreases(accounts, token):
    sender_balance = token.balanceOf(accounts[1])
    amount = sender_balance // 4
    token.transfer(accounts[2], amount, {'from': accounts[1]})
    assert token.balanceOf(accounts[1]) == sender_balance - amount
"""
