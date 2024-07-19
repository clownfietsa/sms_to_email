import 'package:telephony_fix/telephony.dart';
import 'models/settings.dart';
import 'email_sender.dart';
import 'settings_storage.dart';

class SMSReceiver {
  final Telephony telephony = Telephony.instance;
  Settings? _settings;

  void listenIncomingSMS(Settings settings) {
    _settings = settings;
    print('Listening for incoming SMS with settings: $_settings');

    // Слушаем входящие SMS
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        print('Foreground: New SMS received: ${message.body}');
        _settings = await SettingsStorage.loadSettings();
        if (_shouldForward(message.body, _settings!.keywordFilter)) {
          await emailSender.sendEmail(message.body ?? '', _settings!, message.address ?? 'Unknown');
        }
      },
      onBackgroundMessage: _onBackgroundMessageHandler,
    );
  }

  void updateSettings(Settings settings) {
    _settings = settings;
    print('Updating settings to: $_settings');
    listenIncomingSMS(settings);  // Перезапускаем слушатель с новыми настройками
  }

  @pragma("vm:entry-point")
  static Future<void> _onBackgroundMessageHandler(SmsMessage message) async {
    print('Background: New SMS received: ${message.body}');
    final settings = await SettingsStorage.loadSettings();
    if (_shouldForward(message.body, settings.keywordFilter)) {
      await emailSender.sendEmail(message.body ?? '', settings, message.address ?? 'Unknown');
    }
  }

  static bool _shouldForward(String? messageBody, String keywordFilter) {
    if (messageBody == null || keywordFilter.isEmpty) {
      return true;
    }
    List<String> keywords = keywordFilter.split(',');
    for (String keyword in keywords) {
      if (messageBody.contains(keyword.trim())) {
        return true;
      }
    }
    return false;
  }
}
