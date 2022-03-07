import React, { useCallback, useEffect, useRef } from 'react';
import { ApplicationModal, useModalOpen, useToggleModal } from '../state/application';
import useOutsideClick from '../hooks/useOutsideClick';
import { Chains } from '../constants';

function Row({
  name,
  chainId,
  onSelect,
}: {
  name: string,
  chainId: string,
  onSelect: (chainId: string) => void,
}): JSX.Element {
  return (
    <div className="hover:bg-gray-200">
      <button type="button" onClick={() => onSelect(chainId)}>
        <div>{name}</div>
      </button>
    </div>
  );
}

export default function TokenMenu(): JSX.Element {
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(ApplicationModal.NETWORK_SELECTOR);
  const toggle = useToggleModal(ApplicationModal.NETWORK_SELECTOR);

  useOutsideClick(node, open ? toggle : undefined);

  const onTokenSelect = useCallback((nextChainId: string) => {
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
          {Chains.map((chain) => <Row key={chain.chainId} name={chain.chainName} chainId={chain.chainId} onSelect={onTokenSelect} />)}
        </div>
      )}
    </div>
  );
}
