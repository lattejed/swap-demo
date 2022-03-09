import React, { useEffect, useState } from 'react';

export default function useSetPageTitle(title: string): void {
  useEffect(() => {
    document.title = title;
  }, [title]);
}
