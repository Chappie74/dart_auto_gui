import 'dart:ffi' as ffi;
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'helpers/helpers.dart';
import 'models.dart';
import 'native_lib.dart';

/// Typedefs for FFI (Foreign Function Interface) NATIVE function signatures
typedef MousePositionNative = NativePoint Function();
typedef MoveNative = ffi.Void Function(
  ffi.Pointer<NativePoint> points,
  ffi.Int32 count,
  ffi.Int32 sleep,
);
typedef MouseDownNative = ffi.Void Function(ffi.Int32 button);
typedef MouseUpNative = ffi.Void Function(ffi.Int32 button);
typedef ClickNative = ffi.Void Function(
    ffi.Int32 button, ffi.Int32 clicks, ffi.Int32 interval);
typedef ScrollNative = ffi.Void Function(ffi.Int32 clicks, ffi.Int32 axis);

/// Typedefs for FFI (Foreign Function Interface) DART function signatures
typedef MoveDart = void Function(
  ffi.Pointer<NativePoint> points,
  int count,
  int sleep,
);
typedef MouseDownDart = void Function(int button);
typedef MouseUpDart = void Function(int button);
typedef ClickDart = void Function(int button, int clicks, int interval);
typedef ScrollDart = void Function(int clicks, int axis);

// ffi function lookup
final MousePositionNative _mousePositionNative = nativeLib
    .lookup<ffi.NativeFunction<MousePositionNative>>('mouse_position')
    .asFunction();

final MoveDart _moveNative =
    nativeLib.lookup<ffi.NativeFunction<MoveNative>>('move').asFunction();

final MouseUpDart _mouseUpNative = nativeLib
    .lookup<ffi.NativeFunction<MouseUpNative>>('mouse_up')
    .asFunction();

final MouseDownDart _mouseDownNative = nativeLib
    .lookup<ffi.NativeFunction<MouseDownNative>>('mouse_down')
    .asFunction();

final ClickDart _clickNative =
    nativeLib.lookup<ffi.NativeFunction<ClickNative>>('click').asFunction();

final ScrollDart _scrollNative =
    nativeLib.lookup<ffi.NativeFunction<ScrollNative>>('scroll').asFunction();

const int _minimumDuration =
    100; // Minimum duration (in ms) to apply smooth movement
const int _minimumSleep =
    10; // Minimum sleep (in ms) between each step in animation

/// Retrieves the current position of the mouse.
///
/// Returns:
///   A [Point] of type [int] representing the (x, y) coordinates of the mouse.
Point<int> mousePosition() {
  final NativePoint nativePoint = _mousePositionNative();
  return Point(nativePoint.x, nativePoint.y);
}

/// Moves the mouse cursor to the xy co-ordinate.
///
/// `point` : [Point] - x,y co-ordinate to move the mouse cursor to.
///
/// `duration` : [Duration] - The amount of time it takes to move the mouse
/// cursor. If duration is zero mouse cursor is moved instantaneously.
///
/// `curve` : [DAGCurve] - The curve function used if the duration is not zero.
void moveTo({
  required Point<int> point,
  Duration duration = Duration.zero,
  DAGCurve curve = DAGCurves.linear,
}) {
  _moveOrDrag(
    point: point,
    action: MouseAction.move,
    duration: duration,
    curve: curve,
  );
}

/// Moves the mouse cursor relative to it's current position.
///
/// `offset` : [DAGSize] - How far left (for negative values of [DAGSize.width]) or
/// right (for positive values of [DAGSize.width]) / up (for positive values of [DAGSize.height])
/// or down (for negative values of [DAGSize.height]) to move the mouse cursor by
///
/// `duration` : [Duration] - The amount of time it takes to move the mouse
/// cursor. If duration is zero mouse cursor is moved instantaneously.
///
/// `curve` : [DAGCurve] - The curve function used if the duration is not zero.
void moveToRel({
  required DAGSize offset,
  Duration duration = Duration.zero,
  DAGCurve curve = DAGCurves.linear,
}) {
  _moveOrDrag(
    offset: offset,
    action: MouseAction.move,
    duration: duration,
    curve: curve,
  );
}

/// Performs releasing a mouse button up (but not down beforehand)
/// at the current mouse position
///
/// `button` : [MouseButton] - The mouse button to press.
void mouseUp({
  required MouseButton button,
}) {
  _mouseUpNative(button.index);
}

/// Performs pressing a mouse button down (but not up afterwards)
/// at the current mouse position
///
/// `button` : [MouseButton] - The mouse button to press.
void mouseDown({
  required MouseButton button,
}) {
  _mouseDownNative(button.index);
}

/// Performs pressing a mouse button down and then releasing immediately it.
///
/// `button` : [MouseButton] - The mouse button to press.
///
/// `clicks` : [int] - The amount of clicks to perform.
///
/// `interval`: [Duration] - The time interval between each click.
void click({
  required MouseButton button,
  int clicks = 1,
  Duration interval = Duration.zero,
}) {
  int sleep = interval.inMilliseconds < _minimumSleep
      ? _minimumSleep
      : interval.inMilliseconds;
  _clickNative(button.index, clicks, sleep);
}

/// Performs a scroll of the mouse forwards or backwards
///
/// `clicks`: [int] - How much to scroll the mouse by
///  a positive (up / right), negative (down / left)
///
/// `axis` : [ScrollAxis] - Direction to scroll. [ScrollAxis.vertical] (up and down)
/// [ScrollAxis.horizontal] (left and right)
void scroll({
  required int clicks,
  ScrollAxis axis = ScrollAxis.vertical,
}) {
  _scrollNative(clicks, axis.index);
}

void _moveOrDrag({
  required MouseAction action,
  Point<int>? point,
  DAGSize offset = const DAGSize(0, 0),
  MouseButton button = MouseButton.left,
  Duration duration = Duration.zero,
  DAGCurve curve = DAGCurves.linear,
}) {
// check to see if parameters results in no mouse movement at all
  if (point == null && offset.longestSide == 0.0) {
    return;
  }

  Point<int> currentMousePosition = mousePosition();
  // set point to current mouse position if point is null;
  point = point ?? currentMousePosition;
  point += Point(
    offset.width.toInt(),
    offset.height.toInt(),
  );

  int sleepTimePerStep = duration.inMilliseconds;
  int numberOfSteps = 1;
  final arena = Arena();
  late final ffi.Pointer<NativePoint> ptr;
  try {
    // If the duration is long enough, generate interpolated steps along a curve
    if (duration.inMilliseconds >= _minimumDuration) {
      numberOfSteps = duration.inMilliseconds ~/ _minimumSleep;
      sleepTimePerStep = duration.inMilliseconds ~/ numberOfSteps;

      ptr = arena<NativePoint>(numberOfSteps);
      for (var i = numberOfSteps - 1; i >= 0; i--) {
        final p = _getPointOnLine(
          p1: currentMousePosition,
          p2: point,
          n: curve.transform(i / numberOfSteps),
        );

        ptr[i]
          ..x = p.x
          ..y = p.y;
      }
    } else {
      ptr = arena<NativePoint>(1);
      ptr[0]
        ..x = point.x
        ..y = point.y;
    }
    switch (action) {
      case MouseAction.move:
        _moveNative(ptr, numberOfSteps, sleepTimePerStep);
        break;
      case MouseAction.drag:
        break;
    }
  } finally {
    arena.releaseAll();
  }
}

Point<int> _getPointOnLine({
  required Point p1,
  required Point p2,
  required double n,
}) {
  assert(n >= 0.0 && n <= 1.0, "parameter n must be between 0.0 and 1.0");

  int x = (((p2.x - p1.x) * n) + p1.x).toInt();
  int y = (((p2.y - p1.y) * n) + p1.y).toInt();
  return Point(x, y);
}
