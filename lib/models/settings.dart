import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final String smtpHost;
  final int smtpPort;
  final bool useSsl;
  final String senderEmail;
  final String senderPassword;
  final String recipientEmail;
  final String keywordFilter;

  Settings({
    required this.smtpHost,
    required this.smtpPort,
    required this.useSsl,
    required this.senderEmail,
    required this.senderPassword,
    required this.recipientEmail,
    required this.keywordFilter,
  });

  static Future<Settings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings(
      smtpHost: prefs.getString('Имя SMTP-сервера') ?? 'postal2.paykeeper.ru',
      smtpPort: prefs.getInt('Порт SMTP-сервера') ?? 465,
      useSsl: prefs.getBool('Сервер использует SSL') ?? false,
      senderEmail: prefs.getString('Название почтового ящика') ?? 'cc@postal2.paykeeper.ru',
      senderPassword: prefs.getString('Пароль к почтовому ящику') ?? 'RXsa7CSlmmG6Swdlc86GOANa',
      recipientEmail: prefs.getString('Почтовый ящик получателя') ?? 'cc@paykeeper.ru',
      keywordFilter: prefs.getString('Фильтр по ключевым словам (разделитель запятая)') ?? 'Тест',
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('smtpHost', smtpHost);
    await prefs.setInt('smtpPort', smtpPort);
    await prefs.setBool('useSsl', useSsl);
    await prefs.setString('senderEmail', senderEmail);
    await prefs.setString('senderPassword', senderPassword);
    await prefs.setString('recipientEmail', recipientEmail);
    await prefs.setString('keywordFilter', keywordFilter);
  }
}
