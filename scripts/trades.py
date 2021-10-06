from brownie import config, accounts, Trades, Collateral, Token
import pandas as pd
import web3


def toWei(x):
    return web3.Web3.toWei(x, "ether")


def fromWei(x):
    return web3.Web3.fromWei(x, "ether")


usdc = Token.deploy("USDC", "USDC", 5000000000000000000, {"from": accounts[0]})
# collateral.deposit(150, {"from": accounts[0], "value": 150})

trades = Trades.deploy(12124124, 3000, usdc, {"from": accounts[0]})
usdc.approve(trades, toWei(5000), {"from": accounts[0]})
usdc.approve(trades, toWei(5000), {"from": accounts[1]})


def to_df(rows):
    columns = ["tradeId", "side", "price", "size", "timestamp", "trader", "state"]
    df = pd.DataFrame(rows, columns=columns)
    df.side = df.side.map({1: "BUY", 2: "SELL"})
    df.state = df.state.map({0: "OPEN", 1: "FILLED", 2: "CANCELLED"})
    return df


def execute_buys():
    trades.enterOrder(2, 8, 10)
    trades.enterOrder(1, 20, 100)
    trades.enterOrder(2, 10, 20)
    trades.enterOrder(2, 10, 10)
    print(to_df(trades.getTrades()))


def execute_sells():
    trades.enterOrder(1, 10, 10)
    trades.enterOrder(1, 12, 10)
    trades.enterOrder(2, 9, 100)

    print(to_df(trades.getTrades()))


def get_bids():
    trades.enterOrder(1, 5, 5)
    trades.enterOrder(1, 3, 5)
    trades.enterOrder(1, 7, 5)
    trades.enterOrder(1, 1, 5)
    trades.enterOrder(1, 9, 5)
    trades.enterOrder(1, 2, 5)
    trades.enterOrder(2, 17, 5)
    trades.enterOrder(2, 11, 5)
    trades.enterOrder(2, 19, 5)
    trades.enterOrder(2, 12, 5)
    # print(trades.getOpenSide(1))
    print(to_df(trades.getOpenSide(1)))


def get_asks():
    trades.enterOrder(2, 17, 5)
    trades.enterOrder(2, 11, 5)
    trades.enterOrder(2, 19, 5)
    trades.enterOrder(2, 12, 5)
    # print(trades.getOpenSide(1))
    print(to_df(trades.getOpenSide(2)))


def get_book():
    """
    trades.enterOrder(1, 5, 5)
    trades.enterOrder(1, 3, 5)
    trades.enterOrder(1, 7, 5)
    trades.enterOrder(1, 1, 5)
    trades.enterOrder(1, 9, 5)
    trades.enterOrder(1, 2, 5)
    trades.enterOrder(2, 17, 5)
    trades.enterOrder(2, 11, 5)
    trades.enterOrder(2, 19, 5)
    trades.enterOrder(2, 12, 5)

    """
    trades.enterOrder(2, 20, 5)
    trades.enterOrder(2, 21, 5)
    trades.enterOrder(2, 22, 5)
    trades.enterOrder(2, 23, 5)

    trades.enterOrder(2, 1, 5)
    trades.enterOrder(2, 2, 5)
    trades.enterOrder(2, 1, 5)
    trades.enterOrder(2, 3, 5)

    print(to_df(trades.getOrderbook()))
    print(trades.getTradersForLiquidation())


def get_best_bid():
    trades.enterOrder(2, 8, 10)
    trades.enterOrder(1, 20, 100)
    # trades.enterOrder(1, 10, 200)
    # trades.enterOrder(1, 10, 200)
    # trades.enterOrder(1, 10, 200)
    print(trades._getBestAsk())


def get_liquidation():
    usdc.approve(trades, toWei(5000), {"from": accounts[1]})
    usdc.mint(accounts[1], toWei(100000))

    trades.enterOrder(1, 4, 5, {"from": accounts[0]})
    trades.enterOrder(1, 5, 5, {"from": accounts[0]})
    trades.enterOrder(1, 5, 50, {"from": accounts[0]})

    trades.enterOrder(2, 3, 5, {"from": accounts[1]})
    trades.enterOrder(2, 3, 5)
    trades.enterOrder(2, 3, 5)

    trades.enterOrder(2, toWei(3), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.25), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.5), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.75), 50, {"from": accounts[1]})

    # print(to_df(trades.getOrderbook()))
    print(trades.getTradersForLiquidation(3000))
    # print(to_df(trades.getOpenSide(1)))
    # print(trades._getBestBid())


def get_liquidation2():
    usdc.mint(accounts[0], toWei(100000))
    usdc.mint(accounts[1], toWei(100000))
    usdc.approve(trades, toWei(5000), {"from": accounts[0]})
    usdc.approve(trades, toWei(5000), {"from": accounts[1]})

    trades.enterOrder(2, toWei(3), 6, {"from": accounts[1]})
    trades.enterOrder(1, toWei(4), 5, {"from": accounts[0]})
    print(type(trades.getTradersForLiquidation(3000)))


def liquidate_position():
    usdc.mint(accounts[0], toWei(100000))
    usdc.mint(accounts[1], toWei(100000))
    usdc.approve(trades, toWei(5000), {"from": accounts[0]})
    usdc.approve(trades, toWei(5000), {"from": accounts[1]})

    trades.enterOrder(2, toWei(3), 5, {"from": accounts[1]})
    trades.enterOrder(1, toWei(4), 5, {"from": accounts[0]})
    print(to_df(trades.getOrderbook()))
    trades.liquidatePosition(0, 3200)
    print(trades.settlePositions(3000))


def main():
    # get_best_bid()
    # execute_buys()
    # execute_sells()
    # get_asks()
    # get_bids()
    # get_book()
    # get_liquidation2()
    liquidate_position()
