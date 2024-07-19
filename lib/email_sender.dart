import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'models/settings.dart';

class EmailSender {
  Future<void> sendEmail(String messageBody, Settings settings, String senderName) async {
    final smtpServer = SmtpServer(
      settings.smtpHost,
      port: settings.smtpPort,
      username: settings.senderEmail,
      password: settings.senderPassword,
      ssl: settings.useSsl,
    );

    final message = Message()
      ..from = Address(settings.senderEmail, 'PayKeeper SMS App')
      ..recipients.addAll(settings.recipientEmails)
      ..subject = 'SMS from $senderName'
      ..text = messageBody;

    try {
      await send(message, smtpServer);
      print('Email sent successfully');
    } on MailerException catch (e) {
      // Обработка ошибки отправки почты
      print('MailerException: $e');
    }
  }
}

final emailSender = EmailSender();
