import React, { useEffect } from 'react';
import {
  ProviderState, useAccounts, useGetAccounts, useGetProvider, useProviderState,
} from '../state/web3';
import truncateAccount from '../utils/truncateAccount';

export default function Account(): JSX.Element {
  const providerState = useProviderState();
  const getProvider = useGetProvider();
  const accounts = useAccounts();
  const getAccounts = useGetAccounts();
  const mainAccount = accounts?.length ? accounts[0] : null;

  useEffect(() => {
    if (providerState === ProviderState.UNKNOWN) {
      getProvider();
    }
  }, [providerState, getProvider]);

  useEffect(() => {
    if (providerState === ProviderState.HAVE_PROVIDER && !mainAccount) {
      getAccounts();
    }
  }, [providerState, mainAccount, getAccounts]);

  const onConnect = (): void => {
    if (providerState === ProviderState.HAVE_PROVIDER) {
      getAccounts();
    }
  };

  return (
    <div className="text-center">
      {!mainAccount && (
      <button type="button" onClick={onConnect}>
        Connect MetaMask
      </button>
      )}
      {mainAccount && (
      <div className="w-32 truncate">{truncateAccount(mainAccount)}</div>
      )}
    </div>
  );
}
