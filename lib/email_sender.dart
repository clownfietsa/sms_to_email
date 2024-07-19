import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'models/settings.dart';

void sendEmail(String messageBody, Settings settings, String senderName) async {
  final smtpServer = SmtpServer(
    settings.smtpHost,
    port: settings.smtpPort,
    username: settings.senderEmail,
    password: settings.senderPassword,
    ssl: settings.useSsl,
  );

  final message = Message()
    ..from = Address(settings.senderEmail, 'PayKeeper SMS App')
    ..recipients.add(settings.recipientEmail)
    ..subject = 'SMS from $senderName'
    ..text = messageBody;

  try {
    await send(message, smtpServer);
  } on MailerException catch (e) {
  }
}
