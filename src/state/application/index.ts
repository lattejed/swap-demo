import { useCallback } from 'react';
import { createSlice } from '@reduxjs/toolkit';
import { useAppSelector, useAppDispatch } from '../hooks';
import { RootState } from '../store';

export enum ApplicationModal {
  NETWORK_SELECTOR,
}

export interface ApplicationState {
  chainId: number;
  openModal: ApplicationModal | null;
}

const initialState: ApplicationState = {
  chainId: 0,
  openModal: null,
};

export const applicationSlice = createSlice({
  name: 'application',
  initialState,
  reducers: {
    updateChainId(state, action) {
      const { chainId } = action.payload;
      state.chainId = chainId;
    },
    setOpenModal(state, action) {
      state.openModal = action.payload;
    },
  },
});

export default applicationSlice.reducer;
export const { updateChainId, setOpenModal } = applicationSlice.actions;

export function useModalOpen(modal: ApplicationModal): boolean {
  const openModal = useAppSelector((state: RootState) => state.application.openModal);
  return openModal === modal;
}

export function useToggleModal(modal: ApplicationModal): () => void {
  const open = useModalOpen(modal);
  const dispatch = useAppDispatch();
  return useCallback(() => dispatch(setOpenModal(open ? null : modal)), [dispatch, modal, open]);
}
