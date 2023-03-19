import 'dart:async';

void Function() debounce(Function fn, int ms) {
  Timer? timer;
  return () {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: ms), () => fn());
  };
}

void Function(T) debounce1<T>(Function(T) fn, int ms) {
  Timer? timer;
  return (T p0) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: ms), () => fn(p0));
  };
}

void Function(T, U) debounce2<T, U>(Function(T, U) fn, int ms) {
  Timer? timer;
  return (T p0, U p1) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: ms), () => fn(p0, p1));
  };
}

void Function(T, U, V) debounce3<T, U, V>(Function(T, U, V) fn, int ms) {
  Timer? timer;
  return (T p0, U p1, V p2) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: ms), () => fn(p0, p1, p2));
  };
}
