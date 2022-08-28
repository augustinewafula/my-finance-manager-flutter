import 'package:flutter/material.dart';
import 'package:my_finance_manager/services/sync_sms_service.dart';
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
      DatabaseHelper databaseHelper = DatabaseHelper();

      Sms sms =
          await saveSmsToLocalDatabase(smsMessage.body ?? '', databaseHelper);

      //TODO: Check if internet is available first
      SyncSmsService smsService = SyncSmsService();
      smsService.uploadSms(sms, databaseHelper);
      smsService.deleteSyncedSms(databaseHelper);
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
