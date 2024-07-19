import 'package:flutter/material.dart';
import 'models/settings.dart';

class SettingsPage extends StatefulWidget {
  final Settings settings;
  final Future<Settings> Function(Settings) onSettingsChanged;

  const SettingsPage({super.key, required this.settings, required this.onSettingsChanged});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _smtpHostController;
  late TextEditingController _smtpPortController;
  late TextEditingController _senderEmailController;
  late TextEditingController _senderPasswordController;
  late TextEditingController _recipientEmailsController;
  late TextEditingController _keywordFilterController;
  late bool _useSsl;

  @override
  void initState() {
    super.initState();
    _smtpHostController = TextEditingController(text: widget.settings.smtpHost);
    _smtpPortController = TextEditingController(text: widget.settings.smtpPort.toString());
    _senderEmailController = TextEditingController(text: widget.settings.senderEmail);
    _senderPasswordController = TextEditingController(text: widget.settings.senderPassword);
    _recipientEmailsController = TextEditingController(text: widget.settings.recipientEmails.join(','));
    _keywordFilterController = TextEditingController(text: widget.settings.keywordFilter);
    _useSsl = widget.settings.useSsl;
  }

  @override
  void dispose() {
    _smtpHostController.dispose();
    _smtpPortController.dispose();
    _senderEmailController.dispose();
    _senderPasswordController.dispose();
    _recipientEmailsController.dispose();
    _keywordFilterController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    final newSettings = Settings(
      smtpHost: _smtpHostController.text,
      smtpPort: int.parse(_smtpPortController.text),
      useSsl: _useSsl,
      senderEmail: _senderEmailController.text,
      senderPassword: _senderPasswordController.text,
      recipientEmails: _recipientEmailsController.text.split(',').map((e) => e.trim()).toList(),
      keywordFilter: _keywordFilterController.text,
    );

    final updatedSettings = await widget.onSettingsChanged(newSettings);
    Navigator.of(context).pop(updatedSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _smtpHostController,
              decoration: const InputDecoration(labelText: 'Имя SMTP-сервера'),
            ),
            TextField(
              controller: _smtpPortController,
              decoration: const InputDecoration(labelText: 'Порт SMTP-сервера'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: const Text('Сервер использует SSL'),
              value: _useSsl,
              onChanged: (bool value) {
                setState(() {
                  _useSsl = value;
                });
              },
            ),
            TextField(
              controller: _senderEmailController,
              decoration: const InputDecoration(labelText: 'Название почтового ящика'),
            ),
            TextField(
              controller: _senderPasswordController,
              decoration: const InputDecoration(labelText: 'Пароль к почтовому ящику'),
              obscureText: true,
            ),
            TextField(
              controller: _recipientEmailsController,
              decoration: const InputDecoration(labelText: 'Почтовые ящики получателей (разделитель запятая)'),
            ),
            TextField(
              controller: _keywordFilterController,
              decoration: const InputDecoration(labelText: 'Фильтр по ключевым словам (разделитель запятая)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
