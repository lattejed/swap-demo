import { useCallback } from 'react';
import { createSlice } from '@reduxjs/toolkit';
import { useAppSelector, useAppDispatch } from '../hooks';
import { RootState } from '../store';

export enum ApplicationModal {
  NETWORK_SELECTOR,
  TOKEN_SELECTOR_A,
  TOKEN_SELECTOR_B,
}

export interface ApplicationState {
  openModal: ApplicationModal | null;
}

const initialState: ApplicationState = {
  openModal: null,
};

export const applicationSlice = createSlice({
  name: 'application',
  initialState,
  reducers: {
    setOpenModal(state, action) {
      state.openModal = action.payload;
    },
  },
});

export default applicationSlice.reducer;
const { setOpenModal } = applicationSlice.actions;

export function useModalOpen(modal: ApplicationModal): boolean {
  const openModal = useAppSelector((state: RootState) => state.application.openModal);
  return openModal === modal;
}

export function useToggleModal(modal: ApplicationModal): () => void {
  const open = useModalOpen(modal);
  const dispatch = useAppDispatch();
  return useCallback(() => dispatch(setOpenModal(open ? null : modal)), [dispatch, modal, open]);
}
