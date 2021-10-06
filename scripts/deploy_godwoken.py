from brownie import accounts, config, Token, Asset, interface, network
from brownie.network.gas.strategies import GasNowScalingStrategy
import web3

DEPLOYER = accounts.add(config["wallets"]["from_ckb_key"])

REQUIRED_CONFIRMATIONS = 1


def toWei(x):
    return web3.Web3.toWei(x, "ether")


def fromWei(x):
    return web3.Web3.fromWei(x, "ether")


# metamask = '0x54Ee86bD6787BfB386c8Cfc7Bd29ee440382a7a6'
# metamask = accounts.add(config["wallets"]["from_key"])


def deploy_collateral():
    ckETH = Token.deploy(
        "Ether", "ckETH", toWei(5000), {"from": DEPLOYER, "allow_revert": True}
    )
    return 1


def main():
    if network.show_active() in ["private"]:
        ...
    deploy_collateral()
