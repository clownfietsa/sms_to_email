import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'service_background.dart';
import 'sms_receiver.dart';
import 'models/settings.dart';
import 'settings_page.dart';

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
  final SMSReceiver _smsReceiver = SMSReceiver();
  Settings? _settings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    Settings loadedSettings = await Settings.load();
    setState(() {
      _settings = loadedSettings;
      _smsReceiver.listenIncomingSMS(_settings!);
    });
  }

  void _openSettings() async {
    final newSettings = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          settings: _settings!,
          onSettingsChanged: (newSettings) async {
            await newSettings.save();
            return newSettings;
          },
        ),
      ),
    );

    if (newSettings != null) {
      setState(() {
        _settings = newSettings;
        _smsReceiver.listenIncomingSMS(_settings!);
      });
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
