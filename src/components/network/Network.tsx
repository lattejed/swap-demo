import React, { useCallback, useEffect, useRef } from 'react';
import { useSearchParams } from 'react-router-dom';
import { ApplicationModal, useModalOpen, useToggleModal } from '../../state/application';
import useOutsideClick from '../../hooks/useOutsideClick';

function Row({
  name,
  chainId,
  onSelect,
}: {
  name: string,
  chainId: number,
  onSelect: (chainId: number) => void,
}): JSX.Element {
  return (
    <button type="button" onClick={() => onSelect(chainId)}>
      <div>{name}</div>
    </button>
  );
}

export default function Network(): JSX.Element {
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(ApplicationModal.NETWORK_SELECTOR);
  const toggle = useToggleModal(ApplicationModal.NETWORK_SELECTOR);

  useOutsideClick(node, toggle);

  const [searchParams, setSearchParams] = useSearchParams();
  const currentChainId = searchParams.get('chainId') || -1;

  useEffect(() => {
    if (currentChainId === -1) {
      setSearchParams({ chainId: (1).toString() }); // TODO: Default chain
    }
  }, [currentChainId, setSearchParams]);

  const onChainSelect = useCallback((chainId: number) => {
    setSearchParams({ chainId: chainId.toString() });
  }, [setSearchParams]);

  // TODO: Chain id consts
  return (
    <div ref={node as never} className="relative">
      <button type="button" onClick={toggle}>
        {currentChainId}
      </button>
      {open && (
      <div className="absolute right-0 top-10 w-64 p-5 border rounded-2xl shadow-md bg-white">
        <Row name="Ethereum - Rinkeby" chainId={1} onSelect={onChainSelect} />
        <Row name="Arbitrum - Testnet" chainId={2} onSelect={onChainSelect} />
      </div>
      )}
    </div>
  );
}
