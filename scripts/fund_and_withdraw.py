from scripts.helpful_scripts import *
from brownie import FundMe


def fund():
    fund_me = FundMe[-1]
    account = get_account()
    entrence_fee = fund_me.getEntranceFee()
    print(f'current entrance fee is {entrence_fee}')
    print('funding')
    fund_me.fund({'from': account, 'value': entrence_fee})

def withdraw():
    fund_me = FundMe[-1]
    fund_me.withdraw({'from': get_account()})

def main():
    fund()
    withdraw()