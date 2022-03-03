import { RefObject, useEffect, useRef } from 'react';

export default function useOutsideClick<T extends HTMLElement>(
  node: RefObject<T | undefined>,
  handler: (() => void),
): void {
  const handlerRef = useRef<(() => void)>(handler);

  useEffect(() => {
    handlerRef.current = handler;

    const handleClick = (event: MouseEvent): void => {
      if (!node.current?.contains(event.target as Node) ?? true) {
        handlerRef.current();
      }
    };
    document.addEventListener('mousedown', handleClick);
    return () => {
      document.removeEventListener('mousedown', handleClick);
    };
  }, [handler, node]);
}
