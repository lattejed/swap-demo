import tokens from './token-list.json';

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

export interface Token {
  id: string,
  name: string,
  address: string,
  symbol: string,
  decimals: number,
  chainId: number,
  logoURI: string,
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

export const Tokens: Token[] = tokens.map((obj) => {
  const token = obj as Token;
  token.id = `${token.chainId}_${token.symbol}_${token.address}`;
  return token;
});

function getTokenMatching(chainId: number, name: string): Token | undefined {
  for (let i = 0; i < Tokens.length; i += 1) {
    const token = Tokens[i];
    if (token.chainId === chainId && token.name === name) {
      return token;
    }
  }
  return undefined;
}

/* eslint-disable @typescript-eslint/no-non-null-assertion */
export function defaultTokensForChain(chainId: number): [Token, Token] {
  switch (chainId) {
    case 1:
      return [
        getTokenMatching(1, 'Wrapped Ether')!,
        getTokenMatching(1, 'Tether USD')!,
      ];
    case 4:
      return [
        getTokenMatching(4, 'Wrapped Ether')!,
        getTokenMatching(4, 'Dai Stablecoin')!,
      ];
    default:
      throw new Error(`Bad chainId ${chainId}`);
  }
}
/* eslint-enable @typescript-eslint/no-non-null-assertion */

// https://github.com/MetaMask/metamask-extension/blob/2585f45bde6fa4ad4dc3fa17f78ef10306c1e4da/shared/constants/network.js
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
