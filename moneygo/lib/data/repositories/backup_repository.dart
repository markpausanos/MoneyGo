import 'dart:io';
import 'package:intl/intl.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class BackupRepository {
  final AppDatabase database;
  final String databaseFilePath;

  BackupRepository(this.databaseFilePath, this.database);

  static const String _backupKey = 'backups';
  static const String _backupFileNamePrefix = 'backup_moneygo_';

  Future<void> addBackup() async {
    final prefs = await SharedPreferences.getInstance();
    String todayFormatted = DateFormat('yyyyMMdd').format(DateTime.now());
    var backupData = prefs.getString(_backupKey) ?? '';
    List<String> backups = backupData.isEmpty ? [] : backupData.split(',');

    String backupFileName = '$_backupFileNamePrefix$todayFormatted.db';
    bool existingBackup = false;

    for (var backup in backups) {
      if (path
          .basename(backup)
          .startsWith('$_backupFileNamePrefix$todayFormatted')) {
        backupFileName = path.basename(backup);
        existingBackup = true;
        break;
      }
    }

    String backupFilePath =
        path.join(path.dirname(databaseFilePath), backupFileName);
    await File(databaseFilePath).copy(backupFilePath);

    while (backups.length >= 5) {
      await File(backups.removeAt(0)).delete();
    }

    backups.add(backupFilePath);

    if (!existingBackup) {
      await prefs.setString(_backupKey, backups.join(','));
    }
  }

  Future<List<String>> getAllBackups() async {
    final prefs = await SharedPreferences.getInstance();

    var backupData = prefs.getString(_backupKey) ?? '';

    List<String> backupList = backupData.isEmpty ? [] : backupData.split(',');

    if (backupList.isEmpty) {
      return [];
    }

    backupList = backupList
        .map((e) => e.split('/').last.split('backup_moneygo_').last.toString())
        .toList();

    return backupList;
  }

  Future<void> deleteBackup(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    var backupData = prefs.getString(_backupKey) ?? '';
    List<String> backups = backupData.isEmpty ? [] : backupData.split(',');

    backups.remove(filePath);
    await prefs.setStringList(_backupKey, backups);
  }

  Future<void> clearAllBackups() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_backupKey);
  }

  Future<void> restoreBackup(String dateFileName) async {
    final prefs = await SharedPreferences.getInstance();

    var backupData = prefs.getString(_backupKey) ?? '';
    List<String> backups = backupData.isEmpty ? [] : backupData.split(',');
    String backupFileName = '$_backupFileNamePrefix$dateFileName';

    String backupFilePath = backups.firstWhere(
        (backup) => path.basename(backup) == backupFileName,
        orElse: () => '');

    if (backupFilePath.isEmpty) {
      throw Exception('Backup file not found');
    }

    final dbFile = File(databaseFilePath);
    final backupFile = File(backupFilePath);

    if (!await backupFile.exists()) {
      throw Exception('Backup file not found');
    }

    await database.close();

    await dbFile.delete();
    await backupFile.copy(databaseFilePath);
  }
}
