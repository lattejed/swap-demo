import React, { useCallback } from 'react';
import useSetPageTitle from '../hooks/useSetPageTitle';
import TokenInput from '../components/TokenInput';
import {
  useSetTokenA, useSetTokenB, useTokenA, useTokenB,
} from '../state/swap';
import { Token } from '../constants';
import { ApplicationModal } from '../state/application';

function Swap(): JSX.Element {
  useSetPageTitle('Swap');

  const tokenA = useTokenA();
  const tokenB = useTokenB();
  const setTokenA = useSetTokenA();
  const setTokenB = useSetTokenB();

  const onTokenAChange = useCallback((nextToken: Token): void => {
    setTokenA(nextToken);
  }, [setTokenA]);

  const onTokenBChange = useCallback((nextToken: Token): void => {
    setTokenB(nextToken);
  }, [setTokenB]);

  return (
    <div className="p-10">
      <div
        className="p-5 border rounded-2xl shadow-md bg-white flex-col space-y-2"
      >
        <div>Swap</div>
        <TokenInput
          modal={ApplicationModal.TOKEN_SELECTOR_A}
          token={tokenA}
          onTokenChange={onTokenAChange}
        />
        <TokenInput
          modal={ApplicationModal.TOKEN_SELECTOR_B}
          token={tokenB}
          onTokenChange={onTokenBChange}
        />
        <div className="">
          1
          {' '}
          {tokenA.symbol}
          {' '}
          =
          {' '}
          1
          {' '}
          {tokenB.symbol}
        </div>
        <button className="w-full h-12 border rounded-2xl" type="button">Swap</button>
      </div>
    </div>
  );
}

export default Swap;
