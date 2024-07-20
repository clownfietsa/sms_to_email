import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'models/settings.dart';

class EmailSender {
  Future<void> sendEmail(String messageBody, Settings settings, String senderName) async {
    if (!_shouldForward(messageBody, settings.keywordFilter)) {
      print('Message does not meet the keyword filter criteria, not sending email.');
      return;
    }

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

  bool _shouldForward(String? messageBody, String keywordFilter) {
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

final emailSender = EmailSender();
