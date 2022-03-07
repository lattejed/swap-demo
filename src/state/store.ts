import { configureStore, ThunkAction, Action } from '@reduxjs/toolkit';
import applicationSlice from './application';
import web3Slice from './web3';
import swapSlice from './swap';

export const store = configureStore({
  reducer: {
    application: applicationSlice,
    web3: web3Slice,
    swap: swapSlice,
  },
});

export type AppDispatch = typeof store.dispatch;
export type RootState = ReturnType<typeof store.getState>;
export type AppThunk<ReturnType = void> = ThunkAction<
  ReturnType,
  RootState,
  unknown,
  Action<string>
>;
