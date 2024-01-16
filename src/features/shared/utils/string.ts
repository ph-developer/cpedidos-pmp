enum Mode {
  startsWith,
  contains,
  endsWith,
}

export const hasQuery = (str: string, query: string, mode: Mode = Mode.contains): boolean => {
  let regExp = query
    .replace(/[\\^$.*+?()[\]{}|]/g, '\\$&')
    .replaceAll('%', '.*')
    .replaceAll('_', '.');

  if (mode === Mode.startsWith) {
    regExp = `^${regExp}`;
  } else if (mode === Mode.endsWith) {
    regExp = `${regExp}$`;
  }

  return RegExp(regExp)
    .test(str);
};
