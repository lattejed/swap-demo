import React, { useCallback, useEffect, useRef } from 'react';
import { ApplicationModal, useModalOpen, useToggleModal } from '../state/application';
import useOutsideClick from '../hooks/useOutsideClick';
import { Tokens, Token } from '../constants';

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
  modal,
}: {
  modal: ApplicationModal
}): JSX.Element {
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(modal);
  const toggle = useToggleModal(modal);

  useOutsideClick(node, open ? toggle : undefined);

  const onTokenSelect = useCallback((token: Token) => {
    //
    toggle();
  }, [toggle]);

  return (
    <div ref={node as never} className="relative">
      <button type="button" onClick={toggle}>
        ETH
      </button>
      {open && (
        <div
          className="absolute right-0 top-10 w-64 p-5 border rounded-2xl shadow-md bg-white"
          onMouseLeave={toggle}
        >
          {Tokens.map((token) => <Row key={token.id} token={token} onSelect={onTokenSelect} />)}
        </div>
      )}
    </div>
  );
}
