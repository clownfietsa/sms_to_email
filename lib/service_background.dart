import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'sms_receiver.dart';
import 'models/settings.dart';
@pragma("vm:entry-point", true)
Future<Settings> getSettings() async {
  return await Settings.load();
}

@pragma("vm:entry-point", true)
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onStart,
    ),
  );
  service.startService();
}

@pragma("vm:entry-point")
Future<bool> onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "SMS to Email Service",
      content: "Ожидаю входящие СМС...",
    );

    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  final settings = await getSettings();
  @pragma("vm:entry-point", true)
  final smsReceiver = SMSReceiver();
  smsReceiver.listenIncomingSMS(settings);

  return true;
}
