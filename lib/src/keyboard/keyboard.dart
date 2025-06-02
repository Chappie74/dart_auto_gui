import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'keyboard_keys.dart';
import '../native_lib.dart';

/// Typedefs for FFI (Foreign Function Interface) NATIVE function signatures
typedef KeyUpNative = ffi.Void Function(ffi.Pointer<Utf8>);
typedef KeyDownNative = ffi.Void Function(ffi.Pointer<Utf8>);
typedef PressNative = ffi.Void Function(
    ffi.Pointer<Utf8>, ffi.Int32, ffi.Int32);
typedef WriteNative = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Int32);
typedef HotkeyNative = ffi.Void Function(
    ffi.Pointer<ffi.Pointer<Utf8>>, ffi.Int32, ffi.Int32);

/// Typedefs for FFI (Foreign Function Interface) DART function signatures
typedef KeyUpDart = void Function(ffi.Pointer<Utf8>);
typedef KeyDownDart = void Function(ffi.Pointer<Utf8>);
typedef PressDart = void Function(ffi.Pointer<Utf8>, int, int);
typedef WriteDart = void Function(ffi.Pointer<Utf8>, int);
typedef HotkeyDart = void Function(ffi.Pointer<ffi.Pointer<Utf8>>, int, int);

// ffi function lookup
final KeyUpDart _keyUpNative =
    nativeLib.lookup<ffi.NativeFunction<KeyUpNative>>('key_up').asFunction();

final KeyUpDart _keyDownNative =
    nativeLib.lookup<ffi.NativeFunction<KeyUpNative>>('key_down').asFunction();

final PressDart _pressNative =
    nativeLib.lookup<ffi.NativeFunction<PressNative>>('press').asFunction();

final WriteDart _writeNative =
    nativeLib.lookup<ffi.NativeFunction<WriteNative>>('write').asFunction();

final HotkeyDart _hotkeyNative =
    nativeLib.lookup<ffi.NativeFunction<HotkeyNative>>('hotkey').asFunction();

const int _minimumInterval = 10;

/// Sets a single key to the up position
///
/// `key`: [String] - String representation of the key
///
void keyUp({
  required String key,
}) {
  assert(supportedKeys.contains(key),
      'Invalid key. Key must be a supported string');
  final keyC = key.toNativeUtf8();
  try {
    _keyUpNative(keyC);
  } finally {
    calloc.free(keyC);
  }
}

/// Sets a single key to the up position
///
/// `key`: [String] - String representation of the key
void keyDown({
  required String key,
}) {
  assert(supportedKeys.contains(key),
      'Invalid key. Key must be a supported string');
  final keyC = key.toNativeUtf8();
  try {
    _keyDownNative(keyC);
  } finally {
    calloc.free(keyC);
  }
}

/// Sets a key down then up to simulate a key press
///
/// `key`: [String] - String representation of the key
///
/// `times`: [int] - Amount of times to press the key
///
/// `interval`: [Duration] - Delay between each key press
void press({
  required String key,
  int times = 1,
  Duration interval = const Duration(
    milliseconds: _minimumInterval,
  ),
}) {
  assert(supportedKeys.contains(key),
      'Invalid key. Key must be a supported string');

  final keyC = key.toNativeUtf8();
  try {
    _pressNative(keyC, times, interval.inMilliseconds);
  } finally {
    calloc.free(keyC);
  }
}

/// Types the characters in the string
///
/// `text`: [String] - String to type
///
/// `interval`: [Duration] - interval between key presses
///
/// `omitInvalid`: [bool] - True to omit unsupported characters found in text,
/// else an error is thrown.
void write({
  required String text,
  Duration interval = const Duration(
    milliseconds: _minimumInterval,
  ),
  bool omitInvalid = false,
}) {
  String newText = '';
  for (var i = 0; i < text.length; i++) {
    String character = text[i];
    if (!supportedKeys.contains(character)) {
      if (!omitInvalid) {
        throw Exception('An invalid character was found: \' $character \'');
      }
      continue;
    } else {
      newText += character;
    }
  }
  final textToWrite = newText.toNativeUtf8();
  try {
    _writeNative(textToWrite, interval.inMilliseconds);
    print('executed write');
  } finally {
    calloc.free(textToWrite);
  }
}

/// Sets the keys to down state in order and releases then in reverse order
///
/// `keys`: [List] of [String] - List of keys to press
///
/// `interval`: [Duration] - Delay between each key press
void hotkey({
  required List<String> keys,
  Duration interval = const Duration(
    milliseconds: 10,
  ),
}) {
  if (keys.isEmpty) return;
  final pointerArray = calloc<ffi.Pointer<Utf8>>(keys.length);
  try {
    for (var i = 0; i < keys.length; i++) {
      if (!supportedKeys.contains(keys[i])) {
        throw 'Invalid key: ${keys[i]}.  Key must be a supported string';
      }
      pointerArray[i] = keys[i].toNativeUtf8();
    }
    _hotkeyNative(pointerArray, keys.length, interval.inMilliseconds);
  } finally {
    // Clean up
    calloc.free(pointerArray);
  }
}
