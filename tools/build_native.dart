import 'dart:io';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final os = Platform.operatingSystem;
  final packageName = 'dart_auto_gui_$os';
  final nativeDir = Directory(path.join(Directory.current.path, os));
  final buildDir = Directory(path.join(nativeDir.path, 'build'));
  final outputDir = Directory(Directory.current.path);

  final sharedLibName = () {
    if (Platform.isWindows) return '$packageName.dll';
    if (Platform.isMacOS) return '$packageName.dylib';
    if (Platform.isLinux) return '$packageName.so';
    throw UnsupportedError('Unsupported platform: $os');
  }();

  final sharedLibSourcePath = () {
    if (Platform.isWindows) {
      return path.join(buildDir.path, 'Release', sharedLibName);
    } else {
      return path.join(buildDir.path, sharedLibName);
    }
  }();
  final sharedLibDestPath = path.join(outputDir.path, sharedLibName);

  print('🛠️ Building $packageName for $os...');
  final buildResult = await Process.run('cmake', ['-B', 'build', '.'],
      workingDirectory: nativeDir.path);
  stdout.write(buildResult.stdout);
  stderr.write(buildResult.stderr);
  final releaseResult = await Process.run(
      'cmake', ['--build', 'build', '--clean-first', '--config', 'Release'],
      workingDirectory: nativeDir.path);
  stdout.write(releaseResult.stdout);
  stderr.write(releaseResult.stderr);

  if (!File(sharedLibSourcePath).existsSync()) {
    print('❌ Build failed $sharedLibSourcePath');
    exit(1);
  }

  outputDir.createSync(recursive: true);
  File(sharedLibSourcePath).copySync(sharedLibDestPath);

  print('✅ Build complete. Output at: ${buildDir.path}');
}
