# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

install-libs:; forge install dapphub/ds-test && forge install rari-capital/solmate && forge install brockelmore/forge-std && forge remappings > ./remappings.txt

update-libs:; forge update

install-solc:; solc-select install 0.8.10 && solc-select use 0.8.10

lint:; solhint 'src/**/*.sol'

build:; forge clean && forge build --optimize --optimize-runs 1000000

test:; forge clean && forge test --optimize --optimize-runs 1000000 -vvv # --ffi # enable if you need the `ffi` cheat code on HEVM

gas-snapshot:; forge clean && forge snapshot --optimize --optimize-runs 1000000

clean:; forge clean

chmod-scripts:; chmod +x ./scripts/*

# hardhat
fork-eth-rinkeby:; npx hardhat node --fork ${ETH_RINKEBY_RPC_URL} --fork-block-number ${ETH_RINKEBY_BLOCK}