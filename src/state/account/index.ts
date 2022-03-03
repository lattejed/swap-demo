import { createSlice } from '@reduxjs/toolkit';

export interface AccountState {
  address: string | null;
}

const initialState: AccountState = {
  address: null,
};

export const accountSlice = createSlice({
  name: 'account',
  initialState,
  reducers: {
    updateAddress(state, action) {
      const { address } = action.payload;
      state.address = address;
    },
  },
});

export const { updateAddress } = accountSlice.actions;
export default accountSlice.reducer;
