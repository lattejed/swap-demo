import React, { useCallback, useRef } from 'react';
import { ApplicationModal, useModalOpen, useToggleModal } from '../state/application';
import useOutsideClick from '../hooks/useOutsideClick';
import { Token, Tokens } from '../constants';
import {
  useSetTokenA, useSetTokenB, useTokenA, useTokenB,
} from '../state/swap';

export enum TokenMenuTag { A, B}

function Row({
  token,
  onSelect,
}: {
  token: Token,
  onSelect: (token: Token) => void,
}): JSX.Element {
  return (
    <div className="hover:bg-gray-200">
      <button type="button" onClick={() => onSelect(token)}>
        <div className="">{token.symbol}</div>
        <div className="text-sm">{token.name}</div>
      </button>
    </div>
  );
}

export default function TokenMenu({
  tag,
}: {
  tag: TokenMenuTag
}): JSX.Element {
  const modal = tag === TokenMenuTag.A
    ? ApplicationModal.TOKEN_SELECTOR_A
    : ApplicationModal.TOKEN_SELECTOR_B;
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(modal);
  const toggle = useToggleModal(modal);

  useOutsideClick(node, open ? toggle : undefined);

  const tokenA = useTokenA();
  const tokenB = useTokenB();
  const setTokenA = useSetTokenA();
  const setTokenB = useSetTokenB();

  const onTokenSelect = useCallback((token: Token) => {
    if (tag === TokenMenuTag.A) {
      setTokenA(token);
    } else {
      setTokenB(token);
    }
    toggle();
  }, [tag, toggle, setTokenA, setTokenB]);

  return (
    <div ref={node as never} className="">
      <button type="button" onClick={toggle}>
        { tag === TokenMenuTag.A ? tokenA : tokenB }
      </button>
      {open && (
        <div
          className="absolute left-0 right-0 top-10 w-64 p-5 border rounded-2xl shadow-md bg-white"
        >
          {Tokens.map((token) => <Row key={token.id} token={token} onSelect={onTokenSelect} />)}
        </div>
      )}
    </div>
  );
}
