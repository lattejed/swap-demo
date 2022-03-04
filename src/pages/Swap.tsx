import React, { useEffect } from 'react';

function Swap(): JSX.Element {
  useEffect(() => {
    document.title = 'Swap';
  }, []);

  return (
    <div className="" />
  );
}

export default Swap;
