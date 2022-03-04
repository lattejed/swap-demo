export interface Chain {
  chainId: string;
  chainName: string;
  nativeCurrency: {
    name: string;
    symbol: string;
    decimals: number;
  };
  rpcUrls: string[];
  blockExplorerUrls?: string[];
}

export const Chains: Chain[] = [
  {
    chainId: '0x1',
    chainName: 'Ethereum Mainnet',
    nativeCurrency: {
      name: 'Ether',
      symbol: 'ETH',
      decimals: 18,
    },
    rpcUrls: [],
  },
  {
    chainId: '0x4',
    chainName: 'Rinkeby Test Network',
    nativeCurrency: {
      name: 'Ether',
      symbol: 'ETH',
      decimals: 18,
    },
    rpcUrls: [],
  },
];

// export const MAINNET_CHAIN_ID = '0x1';
// export const ROPSTEN_CHAIN_ID = '0x3';
// export const RINKEBY_CHAIN_ID = '0x4';
// export const GOERLI_CHAIN_ID = '0x5';
// export const KOVAN_CHAIN_ID = '0x2a';
// export const LOCALHOST_CHAIN_ID = '0x539';
// export const BSC_CHAIN_ID = '0x38';
// export const OPTIMISM_CHAIN_ID = '0xa';
// export const OPTIMISM_TESTNET_CHAIN_ID = '0x45';
// export const POLYGON_CHAIN_ID = '0x89';
// export const AVALANCHE_CHAIN_ID = '0xa86a';
// export const FANTOM_CHAIN_ID = '0xfa';
// export const CELO_CHAIN_ID = '0xa4ec';
