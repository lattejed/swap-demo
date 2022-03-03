import { configureStore, ThunkAction, Action } from '@reduxjs/toolkit';
import applicationSlice from './application';
import accountSlice from './account';
import counterSlice from '../components/counter/counterSlice';

export const store = configureStore({
  reducer: {
    application: applicationSlice,
    account: accountSlice,
    counter: counterSlice, // TODO:
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
