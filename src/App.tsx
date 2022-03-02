import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import Swap from './pages/Swap';

function App(): JSX.Element {
  return (
    <div className="">
      <header className="">
        <img src="https://plchldr.co/i/150x150" className="" alt="logo" />
      </header>
      <Routes>
        <Route path="/" element={<Navigate to="/swap" />} />
        <Route path="/swap" element={<Swap />} />
      </Routes>
    </div>
  );
}

export default App;
