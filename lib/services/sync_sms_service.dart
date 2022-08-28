import 'package:http/http.dart';
import 'package:my_finance_manager/services/rest_api_service.dart';

import '../helpers/database_helper.dart';

class SyncSmsService {
  Future<void> init() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await syncSms(databaseHelper);
    await deleteSyncedSms(databaseHelper);
  }

  Future<void> syncSms(DatabaseHelper databaseHelper) async {
    List unSyncedSms =
        await databaseHelper.searchSms(column: 'synced', value: '0');
    for (final sms in unSyncedSms) {
      await uploadSms(sms, databaseHelper);
    }
  }

  Future<void> uploadSms(sms, DatabaseHelper databaseHelper) async {
    Response response = await mpesaTransaction(sms.body);
    sms.synced = 1;
    if (response.statusCode == 201) {
      await databaseHelper.updateSms(sms);
    }
  }

  Future<void> deleteSyncedSms(DatabaseHelper databaseHelper) async {
    List unSyncedSms =
        await databaseHelper.searchSms(column: 'synced', value: '1');
    for (final sms in unSyncedSms) {
      await databaseHelper.deleteSms(sms.id);
    }
  }
}
