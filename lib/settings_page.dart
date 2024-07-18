import 'package:flutter/material.dart';
import 'models/settings.dart';

class SettingsPage extends StatefulWidget {
  final Settings settings;
  final Future<Settings> Function(Settings) onSettingsChanged;

  SettingsPage({required this.settings, required this.onSettingsChanged});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _smtpHostController;
  late TextEditingController _smtpPortController;
  late TextEditingController _senderEmailController;
  late TextEditingController _senderPasswordController;
  late TextEditingController _recipientEmailController;
  late TextEditingController _keywordFilterController;
  late bool _useSsl;

  @override
  void initState() {
    super.initState();
    _smtpHostController = TextEditingController(text: widget.settings.smtpHost);
    _smtpPortController = TextEditingController(text: widget.settings.smtpPort.toString());
    _senderEmailController = TextEditingController(text: widget.settings.senderEmail);
    _senderPasswordController = TextEditingController(text: widget.settings.senderPassword);
    _recipientEmailController = TextEditingController(text: widget.settings.recipientEmail);
    _keywordFilterController = TextEditingController(text: widget.settings.keywordFilter);
    _useSsl = widget.settings.useSsl;
  }

  @override
  void dispose() {
    _smtpHostController.dispose();
    _smtpPortController.dispose();
    _senderEmailController.dispose();
    _senderPasswordController.dispose();
    _recipientEmailController.dispose();
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
      recipientEmail: _recipientEmailController.text,
      keywordFilter: _keywordFilterController.text,
    );

    final updatedSettings = await widget.onSettingsChanged(newSettings);
    Navigator.of(context).pop(updatedSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _smtpHostController,
              decoration: InputDecoration(labelText: 'SMTP Host'),
            ),
            TextField(
              controller: _smtpPortController,
              decoration: InputDecoration(labelText: 'SMTP Port'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: Text('Use SSL'),
              value: _useSsl,
              onChanged: (bool value) {
                setState(() {
                  _useSsl = value;
                });
              },
            ),
            TextField(
              controller: _senderEmailController,
              decoration: InputDecoration(labelText: 'Sender Email'),
            ),
            TextField(
              controller: _senderPasswordController,
              decoration: InputDecoration(labelText: 'Sender Password'),
              obscureText: true,
            ),
            TextField(
              controller: _recipientEmailController,
              decoration: InputDecoration(labelText: 'Recipient Email'),
            ),
            TextField(
              controller: _keywordFilterController,
              decoration: InputDecoration(labelText: 'Keyword Filter (comma separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
