import { configureStore, ThunkAction, Action } from '@reduxjs/toolkit';
import applicationSlice from './application';
import accountSlice from './account';
import web3Slice from './web3';

export const store = configureStore({
  reducer: {
    application: applicationSlice,
    account: accountSlice,
    web3: web3Slice,
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
