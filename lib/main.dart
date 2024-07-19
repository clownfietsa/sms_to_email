import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'service_background.dart';
import 'models/settings.dart';
import 'settings_page.dart';
import 'settings_storage.dart';
import 'sms_receiver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissionsAndInitializeService();
  runApp(const MyApp());
}

Future<void> _requestPermissionsAndInitializeService() async {
  await Permission.ignoreBatteryOptimizations.request();
  await initializeService();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Settings? _settings;
  final SMSReceiver _smsReceiver = SMSReceiver();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settings = await SettingsStorage.loadSettings();
    if (_settings != null) {
      _smsReceiver.listenIncomingSMS(_settings!);
    }
    setState(() {});
  }

  void _openSettings() async {
    final newSettings = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          settings: _settings!,
          onSettingsChanged: (newSettings) async {
            await SettingsStorage.saveSettings(newSettings);
            return newSettings;
          },
        ),
      ),
    );

    if (newSettings != null) {
      setState(() {
        _settings = newSettings;
        print('New settings applied: $_settings');
        _smsReceiver.updateSettings(_settings!);
      });

      // Restart the service to apply new settings
      print('Stopping service to apply new settings...');
      await stopService();
      print('Service stopped.');
      await initializeService();
      print('Service initialized.');
      _smsReceiver.listenIncomingSMS(_settings!); // Restart listener
      print('SMS listener restarted with new settings.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS to Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Center(
        child: _settings == null
            ? const CircularProgressIndicator()
            : const Text('Ожидаю входящие СМС'),
      ),
    );
  }
}
