# Project Title

CryptoRide: ERC20 Token based Car Pooling Services

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites 

Tools needed

1. Truffle Framework >= 5.1.17 ( npm install -g truffle )
2. Ganache Tool ( link: https://www.trufflesuite.com/ganache )
3. Solidity Compiler >= 0.6.0
4. Text Editor (vs code)

### Installing

How to clone the repository on your local machine

```
mkdir folder_name
cd folder_name
```

```
git init
```
```
git clone git@github.com:kuldeep23907/CryptoRide-ERC20-token-based-Ethereum-Project.git
```

Go to the directory where the repo has been cloned. Run the following command as per requirement.

To compile the smart contracts
```
truffle compile
```

To deploy the contract on blockchain. Before migrating, so ensure that either ganache(local blockchain) is running or select an ethereum testnet(rinkbey etc.) blockchain. To use testnet, make suitable changes in `truffle-config.js` network object.
```
truffle migrate
```

To run the test written for the contracts
```
truffle test
```

## Drivers List:

| System | Driver |
| --- | --- |
| Platform 						 | Ethereum			|
| Framework | Truffle	|
| Language				 | Solidity		|
| Blockchain 					 | Ganache		|
| UI 					 | React			|

