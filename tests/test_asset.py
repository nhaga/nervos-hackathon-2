def test_asset(asset, token):
    assert asset.underlyingAddress() == token.address


def test_currency(asset, usdc):
    assert asset.currencyAddress() == usdc.address


def test_add_option(asset):
    strike = 3100
    year = 2021
    month = 9
    day = 15
    assert asset.addOption(year, month, day, strike)


"""
def test_collateral(asset):
    assert asset.collateral() == collateral.address
"""
