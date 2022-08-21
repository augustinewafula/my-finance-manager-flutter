import 'package:flutter/material.dart';
import 'package:my_finance_manager/config/routes/routes.dart';
import 'package:telephony/telephony.dart';

import 'helpers/database_helper.dart';
import 'models/sms.dart';

void main() {
  runApp(const MyApp());
}

const validAddresses = ['MPESA', '+254720810670'];

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

  var savedSms = await databaseHelper.getSms();
  print(savedSms);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Finance Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes(),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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

  @override
  void initState() {
    requestPermissions();
    registerSmsListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed("/screens.sign_in");
              },
              child: const Text("TEXT BUTTON"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
