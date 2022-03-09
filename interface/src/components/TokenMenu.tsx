import React, { useCallback, useRef } from 'react';
import { ApplicationModal, useModalOpen, useToggleModal } from '../state/application';
import useOutsideClick from '../hooks/useOutsideClick';
import { Token, Tokens } from '../constants';

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
  token,
  onTokenChange,
}: {
  modal: ApplicationModal,
  token: Token,
  onTokenChange: (token: Token) => void,
}): JSX.Element {
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(modal);
  const toggle = useToggleModal(modal);

  useOutsideClick(node, open ? toggle : undefined);

  const onSelect = useCallback((nextToken: Token) => {
    onTokenChange(nextToken);
    toggle();
  }, [onTokenChange, toggle]);

  return (
    <div ref={node as never} className="">
      <button type="button" onClick={toggle}>
        { token.symbol }
      </button>
      {open && (
        <div
          className="absolute left-0 right-0 top-10 w-64 p-5 border rounded-2xl shadow-md bg-white"
        >
          {Tokens.map((aToken) => <Row key={aToken.id} token={aToken} onSelect={onSelect} />)}
        </div>
      )}
    </div>
  );
}
