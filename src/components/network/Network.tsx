import React, { useCallback, useEffect, useRef } from 'react';
import { useSearchParams } from 'react-router-dom';
import { ApplicationModal, useModalOpen, useToggleModal } from '../../state/application';
import useOutsideClick from '../../hooks/useOutsideClick';
import { ChainId, DEFAULT_CHAIN_ID } from '../../constants';

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
  const currentChainId = searchParams.get('chainId') || null;

  useEffect(() => {
    if (currentChainId === null) {
      setSearchParams({ chainId: DEFAULT_CHAIN_ID.toString() });
    }
  }, [currentChainId, setSearchParams]);

  const onChainSelect = useCallback((chainId: number) => {
    setSearchParams({ chainId: chainId.toString() });
  }, [setSearchParams]);

  return (
    <div ref={node as never} className="relative">
      <button type="button" onClick={toggle}>
        {currentChainId}
      </button>
      {open && (
      <div className="absolute right-0 top-10 w-64 p-5 border rounded-2xl shadow-md bg-white">
        <Row name="Ethereum - Rinkeby" chainId={ChainId.ETHEREUM_RINKEBY} onSelect={onChainSelect} />
        <Row name="Arbitrum - Rinkeby" chainId={ChainId.ARBITRUM_RINKEBY} onSelect={onChainSelect} />
        <Row name="Optimism - Goerli" chainId={ChainId.OPTIMISM_GOERLI} onSelect={onChainSelect} />
      </div>
      )}
    </div>
  );
}
