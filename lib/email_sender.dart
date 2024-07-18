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
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n' + e.toString());
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
