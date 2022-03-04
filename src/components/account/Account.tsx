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

  useEffect(() => {
    if (providerState === ProviderState.UNKNOWN) {
      getProvider();
    }
  }, [providerState, getProvider]);

  useEffect(() => {
    if (providerState === ProviderState.HAVE_PROVIDER && accounts === null) {
      getAccounts();
    }
  }, [providerState, getAccounts, accounts]);
  return (
    <div className="text-center">
      {accounts && accounts.length && (
      <div className="w-32 truncate">{truncateAccount(accounts[0])}</div>
      )}
    </div>
  );
}
