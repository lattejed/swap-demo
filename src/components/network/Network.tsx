import React, { useRef } from 'react';
import { ApplicationModal, useModalOpen, useToggleModal } from '../../state/application';
import useOnClickOutside from '../../hooks/useOnClickOutside';

export default function Network(): JSX.Element {
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(ApplicationModal.NETWORK_SELECTOR);
  const toggle = useToggleModal(ApplicationModal.NETWORK_SELECTOR);

  useOnClickOutside(node, toggle);

  return (
    <div ref={node as any} className="">
      <button type="button" onClick={toggle}>
        <img src="https://plchldr.co/i/24x24" className="" alt="eth" />
      </button>
      {open && (
      <div>IS OPEN</div>
      )}
    </div>
  );
}
