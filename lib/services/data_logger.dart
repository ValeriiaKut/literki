import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../data/module.dart';

class SessionEntry {
  final DateTime timestamp;
  final Module module;
  final String item;
  final int level;
  final int attempt;
  final int durationSeconds;
  final int score;

  SessionEntry({
    required this.timestamp,
    required this.module,
    required this.item,
    required this.level,
    required this.attempt,
    required this.durationSeconds,
    required this.score,
  });

  String toCsvRow() => [
        timestamp.toIso8601String(),
        module.id,
        item,
        level,
        attempt,
        durationSeconds,
        score,
      ].join(',');

  static SessionEntry? tryParse(String row) {
    final parts = row.split(',');
    if (parts.length != 7) return null;
    try {
      return SessionEntry(
        timestamp: DateTime.parse(parts[0]),
        module: Module.fromId(parts[1]),
        item: parts[2],
        level: int.parse(parts[3]),
        attempt: int.parse(parts[4]),
        durationSeconds: int.parse(parts[5]),
        score: int.parse(parts[6]),
      );
    } catch (_) {
      return null;
    }
  }
}

class DataLogger {
  static const _fileName = 'literki_raport.csv';
  static const _csvHeader =
      'timestamp,module,item,level,attempt,duration_sec,score';

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) {
      await file.writeAsString('$_csvHeader\n');
    }
    return file;
  }

  static Future<void> logAttempt({
    required Module module,
    required String item,
    required int level,
    required int attempt,
    required int durationSeconds,
    required int score,
  }) async {
    try {
      final file = await _getFile();
      final entry = SessionEntry(
        timestamp: DateTime.now(),
        module: module,
        item: item,
        level: level,
        attempt: attempt,
        durationSeconds: durationSeconds,
        score: score,
      );
      await file.writeAsString('${entry.toCsvRow()}\n', mode: FileMode.append);
    } catch (e) {
      debugPrint('DataLogger.logAttempt failed: $e');
    }
  }

  static Future<List<SessionEntry>> loadEntries() async {
    try {
      final file = await _getFile();
      final lines = await file.readAsLines();
      return lines
          .skip(1)
          .map(SessionEntry.tryParse)
          .whereType<SessionEntry>()
          .toList();
    } catch (e) {
      debugPrint('DataLogger.loadEntries failed: $e');
      return [];
    }
  }

  static Future<void> clear() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_fileName');
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('DataLogger.clear failed: $e');
    }
  }

  static Future<String> getFilePath() async {
    final file = await _getFile();
    return file.path;
  }
}
