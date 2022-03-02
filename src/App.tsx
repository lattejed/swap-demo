import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import Network from './features/network/Network';
import Account from './features/account/Account';
import Swap from './pages/Swap';

export default function App(): JSX.Element {
  return (
    <div className="">
      <header className="p-5">
        <div className="flex justify-between">
          <img src="https://plchldr.co/i/24x24" className="" alt="logo" />
          <div className="flex space-x-5">
            <Network />
            <Account />
          </div>
        </div>
      </header>
      <Routes>
        <Route path="/" element={<Navigate to="/swap" />} />
        <Route path="/swap" element={<Swap />} />
      </Routes>
    </div>
  );
}
