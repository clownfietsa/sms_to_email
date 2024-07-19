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
        smtpHost: 'smtp.yandex.ru',
        smtpPort: 465,
        useSsl: true,
        senderEmail: 'ap@paykeeper.ru',
        senderPassword: 'XVoSej8nNDUQ8F6!',
        recipientEmails: ['at@paykeeper.ru'],
        keywordFilter: 'TEST',
      );
    }
  }
}