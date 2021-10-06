from brownie import accounts, config, Token, Asset, interface, network
import web3
import json


def toWei(x):
    return web3.Web3.toWei(x, "ether")


def fromWei(x):
    return web3.Web3.fromWei(x, "ether")


metamask = accounts.add(config["wallets"]["from_key"])
nervos = accounts.add(config["wallets"]["from_ckb_key"])


def update_address(file, address):
    with open(file) as f:
        lines = f.readlines()
        lines[0] = f"const address = '{address}'\n"
    with open(file, "w") as f:
        f.writelines(lines)


def update_abi(file, origin):
    path = r"build/contracts/"
    with open(path + origin) as f:
        data = json.load(f)
        abi = data.get("abi")
    with open(file) as f:
        lines = f.readlines()
        lines[1] = f"const ABI = {json.dumps(abi)}\n"
    with open(file, "w") as f:
        f.writelines(lines)


def fund_accounts():
    for n in range(2, 10):
        accounts[n].transfer(metamask, "10 ether", required_confs=0, silent=True)


def deploy_collateral():
    ckETH = Token.deploy("Ether", "ckETH", 5000, {"from": metamask})
    usdc = Token.deploy("USDC", "USDC", toWei(500000), {"from": metamask})

    usdc.mint(metamask, toWei(500000))
    usdc.mint(nervos, toWei(500000))
    metamask.transfer(nervos, "10 ether", required_confs=0, silent=True)

    update_address("client/src/constants/currencyContract.js", usdc.address)
    update_abi("client/src/constants/currencyContract.js", "Token.json")

    asset = Asset.deploy(ckETH, usdc, {"from": metamask})

    strike = 3100
    year = 2021
    month = 12
    day = 15
    asset.addOption(year, month, day, strike)

    """
    trades = interface.TradesInterface(asset.activeOptionAddress())

    usdc.mint(accounts[0], toWei(100000))
    usdc.mint(accounts[1], toWei(100000))
    usdc.approve(trades, toWei(5000000), {"from": metamask})
    usdc.approve(trades, toWei(5000000), {"from": accounts[1]})
    usdc.approve(trades, toWei(5000000), {"from": accounts[0]})

    trades.enterOrder(2, toWei(3), 6, {"from": accounts[1]})
    trades.enterOrder(1, toWei(4), 5, {"from": accounts[0]})

    trades.enterOrder(2, toWei(3), 5, {"from": accounts[1]})
    # trades.enterOrder(2, 3, 5)
    # trades.enterOrder(2, 3, 5)

    trades.enterOrder(2, toWei(3), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.25), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.5), 50, {"from": accounts[1]})
    trades.enterOrder(1, toWei(1.75), 50, {"from": accounts[1]})
    """

    update_address("client/src/constants/assetContract.js", asset)
    update_abi("client/src/constants/assetContract.js", "Asset.json")

    update_address("client/src/constants/tradeContract.js", asset.activeOptionAddress())
    update_abi("client/src/constants/tradeContract.js", "Trades.json")


def main():
    if network.show_active() in ["private"]:
        fund_accounts()
    deploy_collateral()
