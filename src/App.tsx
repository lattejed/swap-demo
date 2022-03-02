import React from 'react';
import { Counter } from './features/counter/Counter';

function App(): JSX.Element {
  return (
    <div className="">
      <header className="">
        <img src="https://plchldr.co/i/150x150" className="" alt="logo" />
        <Counter />
        <p className="">
          Edit
          {' '}
          <code>src/App.tsx</code>
          {' '}
          and save to reload.
        </p>
        <span>
          <span>Learn </span>
          <a
            className=""
            href="https://reactjs.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            React
          </a>
          <span>, </span>
          <a
            className=""
            href="https://redux.js.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            Redux
          </a>
          <span>, </span>
          <a
            className=""
            href="https://redux-toolkit.js.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            Redux Toolkit
          </a>
          ,
          <span> and </span>
          <a
            className=""
            href="https://react-redux.js.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            React Redux
          </a>
        </span>
      </header>
    </div>
  );
}

export default App;
