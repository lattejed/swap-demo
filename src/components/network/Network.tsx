import React, { useCallback, useEffect, useRef } from 'react';
import { ApplicationModal, useModalOpen, useToggleModal } from '../../state/application';
import {
  ProviderState, useChainId, useGetChainId, useSetChainId, useProviderState,
} from '../../state/web3';
import useOutsideClick from '../../hooks/useOutsideClick';
import { Chains } from '../../constants';

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

export default function Network(): JSX.Element {
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(ApplicationModal.NETWORK_SELECTOR);
  const toggle = useToggleModal(ApplicationModal.NETWORK_SELECTOR);

  useOutsideClick(node, open ? toggle : undefined);

  const providerState = useProviderState();
  const chainId = useChainId();
  const getChainId = useGetChainId();
  const setChainId = useSetChainId();

  const onChainSelect = useCallback((nextChainId: string) => {
    setChainId(nextChainId);
    toggle();
  }, [setChainId, toggle]);

  useEffect(() => {
    if (providerState === ProviderState.HAVE_PROVIDER && chainId === null) {
      getChainId();
    }
  }, [providerState, chainId, getChainId]);

  return (
    <div ref={node as never} className="relative">
      <button type="button" onClick={toggle}>
        {chainId}
      </button>
      {open && (
      <div
        className="absolute right-0 top-10 w-64 p-5 border rounded-2xl shadow-md bg-white"
        onMouseLeave={toggle}
      >
        {Chains.map((chain) => <Row key={chain.chainId} name={chain.chainName} chainId={chain.chainId} onSelect={onChainSelect} />)}
      </div>
      )}
    </div>
  );
}
