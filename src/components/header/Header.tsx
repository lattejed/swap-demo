import React, { useEffect } from 'react';
import Network from '../network/Network';
import Account from '../account/Account';

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
