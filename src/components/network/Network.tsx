import React, { useRef } from 'react';
import { ApplicationModal, useModalOpen, useToggleModal } from '../../state/application';
import useOutsideClick from '../../hooks/useOutsideClick';

export default function Network(): JSX.Element {
  const node = useRef<HTMLDivElement>();
  const open = useModalOpen(ApplicationModal.NETWORK_SELECTOR);
  const toggle = useToggleModal(ApplicationModal.NETWORK_SELECTOR);

  useOutsideClick(node, toggle);

  return (
    <div ref={node as never} className="">
      <button type="button" onClick={toggle}>
        <img src="https://plchldr.co/i/24x24" className="" alt="eth" />
      </button>
      {open && (
      <div>IS OPEN</div>
      )}
    </div>
  );
}
