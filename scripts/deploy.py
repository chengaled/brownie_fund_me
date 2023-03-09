from brownie import FundMe, accounts, config, network, MockV3Aggregator
from scripts.helpful_scripts import *


def deploy_fund_me():
    account = get_account()
    # if we are on a develoment/local network deploy mock
    if network.show_active() not in LOCAL_BLOACKCHAIN_ENVIRONMENTS:
        price_feed = config['networks'][network.show_active()]['eth_usd_price_feed']
    else:
         deploy_mock()
         price_feed = MockV3Aggregator[-1].address

    print('Deloying contract..')
    fund_me = FundMe.deploy(price_feed, {'from': account}, 
                            publish_source=config['networks'][network.show_active()].get('verify'))   

    
def main(): 
    deploy_fund_me()