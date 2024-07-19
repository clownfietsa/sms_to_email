import 'package:telephony_fix/telephony.dart';
import 'models/settings.dart';
import 'email_sender.dart';

class SMSReceiver {
  final Telephony telephony = Telephony.instance;
  
  void listenIncomingSMS(Settings settings) {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        if (_shouldForward(message.body, settings.keywordFilter)) {
          // Ensure the settings are up-to-date before sending email
          final updatedSettings = await Settings.load();
          sendEmail(message.body ?? '', updatedSettings, message.address ?? 'Unknown');
        }
      },
      onBackgroundMessage: _onBackgroundMessageHandler,
    );
  }

  @pragma("vm:entry-point")
  static void _onBackgroundMessageHandler(SmsMessage message) async {
    final settings = await Settings.load();
    if (_shouldForward(message.body, settings.keywordFilter)) {
      sendEmail(message.body ?? '', settings, message.address ?? 'Unknown');
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
