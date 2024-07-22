import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'models/settings.dart';
import 'dart:convert';

class SettingsStorage {
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/settings.txt';
  }

  static Future<void> saveSettings(Settings settings) async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    await file.writeAsString(jsonEncode(settings.toJson()));
  }

  static Future<Settings> loadSettings() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      final contents = await file.readAsString();
      final json = jsonDecode(contents);
      return Settings.fromJson(json);
    } catch (e) {
      // Если файл не существует или произошла ошибка чтения, возвращаем настройки по умолчанию
      print('Error loading settings: $e');
      return Settings(
        smtpHost: 'smtp.example.com',
        smtpPort: 465,
        useSsl: true,
        senderEmail: 'test@example.com',
        senderPassword: '',
        recipientEmails: ['test@example.com'],
        keywordFilter: 'test',
      );
    }
  }
}
