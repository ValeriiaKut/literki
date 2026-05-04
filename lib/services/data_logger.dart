import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SessionEntry {
  final DateTime timestamp;
  final String modul;
  final String element;
  final int numerProby;
  final int czasSekundy;
  final int wynik;

  SessionEntry({
    required this.timestamp,
    required this.modul,
    required this.element,
    required this.numerProby,
    required this.czasSekundy,
    required this.wynik,
  });

  String toCsvRow() {
    final ts = timestamp.toIso8601String();
    return '$ts,$modul,$element,$numerProby,$czasSekundy,$wynik';
  }

  static SessionEntry fromCsvRow(String row) {
    final parts = row.split(',');
    return SessionEntry(
      timestamp: DateTime.parse(parts[0]),
      modul: parts[1],
      element: parts[2],
      numerProby: int.parse(parts[3]),
      czasSekundy: int.parse(parts[4]),
      wynik: int.parse(parts[5]),
    );
  }
}

class DataLogger {
  static const _fileName = 'literki_raport.csv';
  static const _csvHeader = 'data,modul,element,numer_proby,czas_sekundy,wynik_gwiazdki';

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) {
      await file.writeAsString('$_csvHeader\n');
    }
    return file;
  }

  static Future<void> logAttempt({
    required String modul,
    required String element,
    required int numerProby,
    required int czasSekundy,
    required int wynik,
  }) async {
    final file = await _getFile();
    final entry = SessionEntry(
      timestamp: DateTime.now(),
      modul: modul,
      element: element,
      numerProby: numerProby,
      czasSekundy: czasSekundy,
      wynik: wynik,
    );
    await file.writeAsString('${entry.toCsvRow()}\n', mode: FileMode.append);
  }

  static Future<List<SessionEntry>> loadEntries() async {
    final file = await _getFile();
    final lines = await file.readAsLines();
    return lines
        .skip(1)
        .where((l) => l.trim().isNotEmpty)
        .map(SessionEntry.fromCsvRow)
        .toList();
  }

  static Future<String> getFilePath() async {
    final file = await _getFile();
    return file.path;
  }
}
