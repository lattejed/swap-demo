import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import Header from './components/header/Header';
import Swap from './pages/Swap';

export default function App(): JSX.Element {
  return (
    <div className="">
      <Header />
      <Routes>
        <Route path="/" element={<Navigate to="/swap" />} />
        <Route path="/swap" element={<Swap />} />
      </Routes>
    </div>
  );
}
