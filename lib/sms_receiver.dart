import 'package:telephony/telephony.dart';
import 'models/settings.dart';
import 'email_sender.dart';

class SMSReceiver {
  final Telephony telephony = Telephony.instance;
  
  void listenIncomingSMS(Settings settings) {
    print('Listening for incoming SMS...');
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print('Received SMS: ${message.body}');
        if (_shouldForward(message.body, settings.keywordFilter)) {
          sendEmail(message.body ?? '', settings, message.address ?? 'Unknown');
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