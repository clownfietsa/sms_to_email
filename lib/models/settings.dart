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

  Map<String, dynamic> toJson() => {
    'smtpHost': smtpHost,
    'smtpPort': smtpPort,
    'useSsl': useSsl,
    'senderEmail': senderEmail,
    'senderPassword': senderPassword,
    'recipientEmails': recipientEmails,
    'keywordFilter': keywordFilter,
  };

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      smtpHost: json['smtpHost'],
      smtpPort: json['smtpPort'],
      useSsl: json['useSsl'],
      senderEmail: json['senderEmail'],
      senderPassword: json['senderPassword'],
      recipientEmails: List<String>.from(json['recipientEmails']),
      keywordFilter: json['keywordFilter'],
    );
  }

  static Future<Settings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return Settings(
      smtpHost: prefs.getString('smtpHost') ?? 'smtp.yandex.ru',
      smtpPort: prefs.getInt('smtpPort') ?? 465,
      useSsl: prefs.getBool('useSsl') ?? true,
      senderEmail: prefs.getString('senderEmail') ?? 'ap@paykeeper.ru',
      senderPassword: prefs.getString('senderPassword') ?? 'XVoSej8nNDUQ8F6!',
      recipientEmails: prefs.getStringList('recipientEmails') ?? ['at@paykeeper.ru'],
      keywordFilter: prefs.getString('keywordFilter') ?? 'TEST',
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
