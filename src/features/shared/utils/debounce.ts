/* eslint-disable no-undef */
type DebounceFn = () => void;
type DebounceFn1<T> = (p0: T) => void;

export function debounce(fn: () => void, ms: number): DebounceFn {
  let timer: NodeJS.Timeout | undefined;

  return () => {
    if (timer) {
      clearTimeout(timer);
    }

    timer = setTimeout(() => {
      fn();
    }, ms);
  };
}

export function debounce1<T>(fn: (p0: T) => void, ms: number): DebounceFn1<T> {
  let timer: NodeJS.Timeout | undefined;

  return (p0: T) => {
    if (timer) {
      clearTimeout(timer);
    }

    timer = setTimeout(() => {
      fn(p0);
    }, ms);
  };
}
