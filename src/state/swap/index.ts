import { createSlice } from '@reduxjs/toolkit';
import { useCallback } from 'react';
import { Token } from '../../constants';
import { useAppDispatch, useAppSelector } from '../hooks';
import { RootState } from '../store';

export interface SwapState {
  tokenA: Token | null;
  tokenB: Token | null;
}

const initialState: SwapState = {
  tokenA: null,
  tokenB: null,
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

export function useTokenA(): Token | null {
  return useAppSelector((state: RootState) => state.swap.tokenA);
}

export function useSetTokenA(): (token: Token) => void {
  const dispatch = useAppDispatch();
  return useCallback((token: Token) => dispatch(setTokenA(token)), [dispatch]);
}

export function useTokenB(): Token | null {
  return useAppSelector((state: RootState) => state.swap.tokenB);
}

export function useSetTokenB(): (token: Token) => void {
  const dispatch = useAppDispatch();
  return useCallback((token: Token) => dispatch(setTokenB(token)), [dispatch]);
}
