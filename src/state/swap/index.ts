import { createSlice } from '@reduxjs/toolkit';
import { useCallback } from 'react';
import { Token, defaultTokensForChain } from '../../constants';
import { useAppDispatch, useAppSelector } from '../hooks';
import { RootState } from '../store';

const [defaultTokenA, defaultTokenB] = defaultTokensForChain(1);

export interface SwapState {
  tokenA: Token;
  tokenB: Token;
}

const initialState: SwapState = {
  tokenA: defaultTokenA,
  tokenB: defaultTokenB,
};

export const swapSlice = createSlice({
  name: 'swap',
  initialState,
  reducers: {
    setTokenA(state, action) {
      const { token } = action.payload;
      state.tokenA = token;
    },
    setTokenB(state, action) {
      const { token } = action.payload;
      state.tokenA = token;
    },
  },
});

export default swapSlice.reducer;
const { setTokenA, setTokenB } = swapSlice.actions;

export function useTokenA(): Token {
  return useAppSelector((state: RootState) => state.swap.tokenA);
}

export function useSetTokenA(): (token: Token) => void {
  const dispatch = useAppDispatch();
  return useCallback((token: Token) => dispatch(setTokenA(token)), [dispatch]);
}

export function useTokenB(): Token {
  return useAppSelector((state: RootState) => state.swap.tokenB);
}

export function useSetTokenB(): (token: Token) => void {
  const dispatch = useAppDispatch();
  return useCallback((token: Token) => dispatch(setTokenB(token)), [dispatch]);
}
