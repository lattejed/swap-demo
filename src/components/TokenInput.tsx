import React, { useState } from 'react';
import TokenMenu from './TokenMenu';
import { ApplicationModal } from '../state/application';

export default function TokenInput({
  modal,
}: {
  modal: ApplicationModal
}): JSX.Element {
  const [value, setValue] = useState('1.000000000000000000');

  return (
    <div className="w-full p-2.5 border rounded-2xl flex-col space-y-5">
      <div className="flex justify-between align-top">
        <input
          className="w-full border-0 focus:ring-0 h-8"
          type="text"
          value={value}
          onChange={(e) => setValue(e.target.value)}
        />
        <TokenMenu modal={modal} />
      </div>
      <div className="text-right">Balance: 0</div>
    </div>
  );
}
