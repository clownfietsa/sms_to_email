import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final String smtpHost;
  final int smtpPort;
  final bool useSsl;
  final String senderEmail;
  final String senderPassword;
  final List<String> recipientEmails;
  final String keywordFilter;

  Settings({
    required this.smtpHost,
    required this.smtpPort,
    required this.useSsl,
    required this.senderEmail,
    required this.senderPassword,
    required this.recipientEmails,
    required this.keywordFilter,
  });

  static Future<Settings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings(
      smtpHost: prefs.getString('smtpHost') ?? 'postal2.paykeeper.ru',
      smtpPort: prefs.getInt('smtpPort') ?? 465,
      useSsl: prefs.getBool('useSsl') ?? false,
      senderEmail: prefs.getString('senderEmail') ?? 'cc@postal2.paykeeper.ru',
      senderPassword: prefs.getString('senderPassword') ?? 'RXsa7CSlmmG6Swdlc86GOANa',
      recipientEmails: (prefs.getStringList('recipientEmails') ?? ['cc@paykeeper.ru']),
      keywordFilter: prefs.getString('keywordFilter') ?? 'Тест',
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('smtpHost', smtpHost);
    await prefs.setInt('smtpPort', smtpPort);
    await prefs.setBool('useSsl', useSsl);
    await prefs.setString('senderEmail', senderEmail);
    await prefs.setString('senderPassword', senderPassword);
    await prefs.setStringList('recipientEmails', recipientEmails);
    await prefs.setString('keywordFilter', keywordFilter);
  }
}
