import { useCallback } from 'react';
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { providers } from 'ethers';
import detectEthereumProvider from '@metamask/detect-provider';
import { useAppSelector, useAppDispatch } from '../hooks';
import { RootState } from '../store';

type Provider = providers.Web3Provider | null;
let globalProvider: Provider = null;

export enum ProviderState {
  UNKNOWN,
  LOADING,
  NO_PROVIDER,
  HAVE_PROVIDER,
}

export interface ApplicationState {
  providerState: ProviderState;
  chainId: string | null,
  accounts: string[] | null,
}

const initialState: ApplicationState = {
  providerState: ProviderState.UNKNOWN,
  chainId: null,
  accounts: null,
};

function handleNetworkChanged(
  network: providers.Network,
  oldNetwork: providers.Network,
): void {
  if (oldNetwork !== null) {
    window.location.reload();
  }
}

function setProvider(provider: Provider): void {
  if (globalProvider !== null) {
    globalProvider.removeAllListeners();
  }
  if (provider !== null) {
    provider.on('network', handleNetworkChanged);
  }
  globalProvider = provider;
}

const getProvider = createAsyncThunk(
  'web3/getProvider',
  async (_, { rejectWithValue }) => {
    try {
      setProvider(null);
      const provider = await detectEthereumProvider({
        mustBeMetaMask: true,
        silent: true,
        timeout: 3000,
      });
      setProvider(new providers.Web3Provider(provider as never, 'any'));
      return null;
    } catch (error) {
      return rejectWithValue(null);
    }
  },
);

const getChainId = createAsyncThunk(
  'web3/getChainId',
  async (_, { rejectWithValue }) => {
    try {
      return globalProvider?.send('eth_chainId', []) as Promise<string>;
    } catch (error) {
      return rejectWithValue(null);
    }
  },
);

const setChainId = createAsyncThunk(
  'web3/setChainId',
  async (chainId: string, { rejectWithValue }) => {
    try {
      globalProvider?.send('wallet_switchEthereumChain', [{ chainId }]);
      return null;
    } catch (error) {
      return rejectWithValue(null);
    }
  },
);

const getAccounts = createAsyncThunk(
  'web3/getAccounts',
  async (_, { rejectWithValue }) => {
    try {
      return globalProvider?.send('eth_requestAccounts', []) as Promise<string[]>;
    } catch (error) {
      return rejectWithValue(null);
    }
  },
);

export const web3Slice = createSlice({
  name: 'web3',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(getProvider.pending, (state) => {
        state.providerState = ProviderState.LOADING;
      })
      .addCase(getProvider.fulfilled, (state) => {
        state.providerState = ProviderState.HAVE_PROVIDER;
      })
      .addCase(getProvider.rejected, (state) => {
        state.providerState = ProviderState.NO_PROVIDER;
      })
      .addCase(getChainId.pending, (state) => {
        state.chainId = null;
      })
      .addCase(getChainId.fulfilled, (state, action) => {
        state.chainId = action.payload;
      })
      .addCase(setChainId.pending, (state) => {
        state.chainId = null;
      })
      .addCase(getAccounts.pending, (state) => {
        state.accounts = null;
      })
      .addCase(getAccounts.fulfilled, (state, action) => {
        state.accounts = action.payload;
      });
  },
});

export default web3Slice.reducer;
// export const {  } = web3Slice.actions;

export function useProviderState(): ProviderState {
  return useAppSelector((state: RootState) => state.web3.providerState);
}

export function useGetProvider(): () => void {
  const dispatch = useAppDispatch();
  return useCallback(() => dispatch(getProvider()), [dispatch]);
}

export function useChainId(): string | null {
  return useAppSelector((state: RootState) => state.web3.chainId);
}

export function useGetChainId(): () => void {
  const dispatch = useAppDispatch();
  return useCallback(() => dispatch(getChainId()), [dispatch]);
}

export function useSetChainId(): (chainId: string) => void {
  const dispatch = useAppDispatch();
  return useCallback((chainId: string) => dispatch(setChainId(chainId)), [dispatch]);
}

export function useAccounts(): string[] | null {
  return useAppSelector((state: RootState) => state.web3.accounts);
}

export function useGetAccounts(): () => void {
  const dispatch = useAppDispatch();
  return useCallback(() => dispatch(getAccounts()), [dispatch]);
}
