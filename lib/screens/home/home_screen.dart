import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../../../config/size_config.dart';
import '../../helpers/database_helper.dart';
import '../../models/sms.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const validAddresses = ['MPESA', '+254720810670'];

  void handleSms(SmsMessage smsMessage) async {
    if (validAddresses.contains(smsMessage.address)) {
      saveSmsToLocalDatabase(smsMessage.body);
    }
  }

  void saveSmsToLocalDatabase(String? body) async {
    if (body == null) {
      return;
    }
    var sms = Sms(id: 0, body: body, synced: 0);

    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.insertSms(sms);
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

  void initState() {
    requestPermissions();
    registerSmsListener();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
        ),
        centerTitle: false,
      ),
      body: const Body(),
    );
  }
}
