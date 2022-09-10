import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_finance_manager/config/routes/routes.dart';
import 'package:my_finance_manager/services/auth.dart';
import 'package:my_finance_manager/services/network_status.dart';
import 'package:my_finance_manager/services/sync_sms_service.dart';
import 'package:telephony/telephony.dart';
import 'package:workmanager/workmanager.dart';

import 'helpers/database_helper.dart';
import 'models/sms.dart';

const validAddresses = ['MPESA', '+254720810670'];

void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    try {
      await dotenv.load();
      bool isInternetAvailable = await NetworkStatus().isInternetAvailable();
      bool isUserLoggedIn = await isAuthenticated();
      if (isInternetAvailable && isUserLoggedIn) {
        await SyncSmsService().init();
      }
    } catch (err) {
      throw Exception(err);
    }
    return Future.value(true);
  });
}

Future main() async {
  await dotenv.load();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
      "auto-sync-sms-identifier", "autoSyncSmsTask",
      frequency: const Duration(hours: 1));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

void syncSms() {}

void handleSms(SmsMessage smsMessage) async {
  if (validAddresses.contains(smsMessage.address)) {
    DatabaseHelper databaseHelper = DatabaseHelper();

    Sms sms =
        await saveSmsToLocalDatabase(smsMessage.body ?? '', databaseHelper);
    await dotenv.load();

    bool isInternetAvailable = await NetworkStatus().isInternetAvailable();
    bool isUserLoggedIn = await isAuthenticated();
    if (isInternetAvailable && isUserLoggedIn) {
      SyncSmsService smsService = SyncSmsService();
      smsService.uploadSms(sms, databaseHelper);
      smsService.deleteSyncedSms(databaseHelper);
    }
  }
}

Future<Sms> saveSmsToLocalDatabase(
    String body, DatabaseHelper databaseHelper) async {
  int id = DateTime.now().millisecondsSinceEpoch;
  Sms sms = Sms(id: id, body: body, synced: 0);

  await databaseHelper.insertSms(sms);

  return sms;
}

void requestPermissions() async {
  Telephony telephony = Telephony.instance;

  bool? permissionsGranted = await telephony.requestSmsPermissions ?? false;
  if (permissionsGranted) {
    registerSmsListener();
  }
}

void registerSmsListener() {
  final Telephony telephony = Telephony.instance;

  telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        handleSms(message);
      },
      onBackgroundMessage: handleSms);
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    requestPermissions();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Finance Manager',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      routes: routes(),
      initialRoute: '/screens.home',
      builder: EasyLoading.init(),
    );
  }
}
