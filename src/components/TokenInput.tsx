import React, { useState } from 'react';

export default function TokenInput(): JSX.Element {
  const [value, setValue] = useState('1.000000000000000000');

  return (
    <div className="p-5 border rounded-2xl">
      <div className="">
        <div className="">
          <input className="w-full" type="text" value={value} onChange={(e) => setValue(e.target.value)} />
          <div>ETH</div>
        </div>
        <div>Balance</div>
      </div>
    </div>
  );
}
