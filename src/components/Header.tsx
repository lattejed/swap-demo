import React from 'react';
import Network from './Network';
import Account from './Account';

export default function Header(): JSX.Element {
  return (
    <header className="p-5">
      <div className="flex justify-between">
        <img src="https://plchldr.co/i/24x24" className="" alt="logo" />
        <div className="flex space-x-5">
          <Network />
          <Account />
        </div>
      </div>
    </header>
  );
}
