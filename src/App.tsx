import React from 'react';
import { Navigate, Route, Routes } from 'react-router-dom';
import Header from './components/Header';
import Swap from './pages/Swap';
import { ProviderState, useProviderState } from './state/web3';

export default function App(): JSX.Element {
  const providerState = useProviderState();
  const needsMetaMask = providerState === ProviderState.NO_PROVIDER;

  return (
    <div className="">
      {needsMetaMask && (
      <div className="flex h-14 bg-amber-400 justify-around items-center">
        <div className="text-center h-6">
          This application requires
          {' '}
          <a href="https://metamask.io/download/" target="_blank" rel="noreferrer">MetaMask</a>
        </div>
      </div>
      )}
      <Header />
      <Routes>
        <Route path="/" element={<Navigate to="/swap" />} />
        <Route path="/swap" element={<Swap />} />
      </Routes>
    </div>
  );
}
