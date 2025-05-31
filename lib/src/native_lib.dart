import 'dart:ffi' as ffi;
import 'dart:io';

final ffi.DynamicLibrary nativeLib = Platform.isWindows
    ? ffi.DynamicLibrary.open('dart_auto_gui_windows.dll')
    : throw UnsupportedError('Only Windows is supported right now');
