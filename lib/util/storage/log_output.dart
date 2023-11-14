import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Writes the log output to a file.
class FileOutput extends LogOutput {
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  FileOutput({
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  Future<void> init() async {
    _sink = (await getDirectoryForLogRecord()).openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  Future<File> getDirectoryForLogRecord() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/myWitWalletLogs.txt');
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
