from brownie import network, accounts, config, MockV3Aggregator
from web3 import Web3

INITIAL_VALUE = 20 ** 10
DECIMALS = 8
LOCAL_BLOACKCHAIN_ENVIRONMENTS = ['development', 'ganache-local']
LOCAL_FORKED_ENVIRONMENTS = ['mainnet-fork', 'mainnet-fork-dev']


def get_account():
    if network.show_active() in LOCAL_BLOACKCHAIN_ENVIRONMENTS + LOCAL_FORKED_ENVIRONMENTS:
        return accounts[0]
    return accounts.add(config['wallets']['from_key'])

def deploy_mock():
    print('deploying mock')
    if len(MockV3Aggregator)>=0:
        MockV3Aggregator.deploy(DECIMALS, INITIAL_VALUE, {'from': get_account()}, 
                                                        publish_source=config['networks'][network.show_active()].get('verify'))