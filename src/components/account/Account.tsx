import React, { useEffect } from 'react';
import {
  ProviderState, useAccounts, useGetAccounts, useGetProvider, useProviderState,
} from '../../state/web3';
import truncateAccount from '../../utils/truncateAccount';

export default function Account(): JSX.Element {
  const providerState = useProviderState();
  const getProvider = useGetProvider();
  const accounts = useAccounts();
  const getAccounts = useGetAccounts();
  const hasAccount = !!accounts?.length;

  useEffect(() => {
    if (providerState === ProviderState.UNKNOWN) {
      getProvider();
    }
  }, [providerState, getProvider]);

  const onConnect = (): void => {
    if (providerState === ProviderState.HAVE_PROVIDER) {
      getAccounts();
    }
  };

  return (
    <div className="text-center">
      {!hasAccount && (
      <button type="button" onClick={onConnect}>
        Connect MetaMask
      </button>
      )}
      {hasAccount && (
      <div className="w-32 truncate">{truncateAccount(accounts![0])}</div>
      )}
    </div>
  );
}
