import React from 'react';
import useSetPageTitle from '../hooks/useSetPageTitle';
import TokenInput from '../components/TokenInput';
import { TokenMenuTag } from '../components/TokenMenu';

function Swap(): JSX.Element {
  useSetPageTitle('Swap');

  return (
    <div className="p-10">
      <div
        className="p-5 border rounded-2xl shadow-md bg-white flex-col space-y-2"
      >
        <div>Swap</div>
        <TokenInput tag={TokenMenuTag.A} />
        <TokenInput tag={TokenMenuTag.B} />
        <div className="">1 ETH = 1 ETH</div>
        <button className="w-full h-12 border rounded-2xl" type="button">Swap</button>
      </div>
    </div>
  );
}

export default Swap;
