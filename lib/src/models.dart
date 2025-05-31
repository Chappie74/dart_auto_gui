import 'dart:ffi' as ffi;

class NativePoint extends ffi.Struct {
  @ffi.Int32()
  external int x;

  @ffi.Int32()
  external int y;
}

enum MouseButton { left, right, middle }

enum MouseAction { move, drag }

enum ScrollAxis { vertical, horizontal }

extension MouseButtonExtension on MouseButton {
  String toShortString() {
    return toString().split('.').last;
  }
}
