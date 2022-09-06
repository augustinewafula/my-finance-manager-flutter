import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_finance_manager/config/routes/routes.dart';
import 'package:my_finance_manager/screens/home/home_screen.dart';
import 'package:my_finance_manager/services/auth.dart';
import 'package:my_finance_manager/services/network_status.dart';
import 'package:my_finance_manager/services/sync_sms_service.dart';
import 'package:telephony/telephony.dart';

import 'helpers/database_helper.dart';
import 'models/sms.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

void handleSms(SmsMessage smsMessage) async {
  print('received sms from ${smsMessage.address}');
  if (HomeScreen.validAddresses.contains(smsMessage.address)) {
    DatabaseHelper databaseHelper = DatabaseHelper();

    Sms sms =
        await saveSmsToLocalDatabase(smsMessage.body ?? '', databaseHelper);
    print('sms id ${sms.id} saved to local database');
    await dotenv.load();

    bool isInternetAvailable = await NetworkStatus().isInternetAvailable();
    if (isInternetAvailable) {
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

  bool? permissionsGranted = await telephony.requestSmsPermissions;
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
    print('init state');
    requestPermissions();
    registerSmsListener();
    print('Token: ${getAuthToken()}');
    print('Email: ${getEmail()}');
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
