import 'dart:async';

void Function() debounce(Function fn, int ms) {
  Timer? timer;
  return () {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: ms), () => fn());
  };
}
