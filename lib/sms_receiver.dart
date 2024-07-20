import 'package:telephony_fix/telephony.dart';
import 'email_sender.dart';
import 'settings_storage.dart';

class SMSReceiver {
  final Telephony telephony = Telephony.instance;

  void listenIncomingSMS() {
    print('Listening for incoming SMS');
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        print('Foreground: New SMS received: ${message.body}');
        final settings = await SettingsStorage.loadSettings();
        await emailSender.sendEmail(message.body ?? '', settings, message.address ?? 'Unknown');
      },
      onBackgroundMessage: _onBackgroundMessageHandler,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> _onBackgroundMessageHandler(SmsMessage message) async {
    print('Background: New SMS received: ${message.body}');
    final settings = await SettingsStorage.loadSettings();
    await emailSender.sendEmail(message.body ?? '', settings, message.address ?? 'Unknown');
  }
}
