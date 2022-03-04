import { useCallback } from 'react';
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { providers } from 'ethers';
import detectEthereumProvider from '@metamask/detect-provider';
import { useAppSelector, useAppDispatch } from '../hooks';
import { RootState } from '../store';

let globalProvider: providers.Web3Provider | null = null;

export enum ProviderState {
  UNKNOWN,
  LOADING,
  NO_PROVIDER,
  HAVE_PROVIDER,
}

export interface ApplicationState {
  providerState: ProviderState;
  accounts: string[] | null,
}

const initialState: ApplicationState = {
  providerState: ProviderState.UNKNOWN,
  accounts: null,
};

const getProvider = createAsyncThunk(
  'web3/getProvider',
  async (_, { rejectWithValue }) => {
    try {
      const provider = await detectEthereumProvider({
        mustBeMetaMask: true,
        silent: true,
        timeout: 3000,
      });
      globalProvider = new providers.Web3Provider(provider as never);
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
        globalProvider = null;
      })
      .addCase(getProvider.fulfilled, (state) => {
        state.providerState = ProviderState.HAVE_PROVIDER;
      })
      .addCase(getProvider.rejected, (state) => {
        state.providerState = ProviderState.NO_PROVIDER;
        globalProvider = null;
      })
      .addCase(getAccounts.pending, (state) => {
        state.accounts = null;
      })
      .addCase(getAccounts.fulfilled, (state, action) => {
        state.accounts = action.payload;
      })
      .addCase(getAccounts.rejected, (state) => {
        state.accounts = null;
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

export function useAccounts(): string[] | null {
  return useAppSelector((state: RootState) => state.web3.accounts);
}

export function useGetAccounts(): () => void {
  const dispatch = useAppDispatch();
  return useCallback(() => dispatch(getAccounts()), [dispatch]);
}
