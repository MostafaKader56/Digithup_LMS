import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import './auth_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _connectionStatus == ConnectivityResult.none
          ? Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .22),
                  Image.asset(
                    "assets/images/login_front.png",
                    height: MediaQuery.of(context).size.height * .27,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('لا يوجد اتصال بالانترنت'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('يرجى التحقق من اتصالك بالانترنت'),
                  ),
                ],
              ),
            )
          : Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .10,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/aktshf-logo.png',
                    fit: BoxFit.cover,

                    height: MediaQuery.of(context).size.height * .27,
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * .22,
                // ),
                // Center(
                //   child: Image.asset(
                //     'assets/images/login_front.png',
                //     fit: BoxFit.cover,
                //     height: MediaQuery.of(context).size.height * .27,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AuthScreen.routeName);
                    },
                    color: kOrangeColor,

                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      // side: const BorderSide(color: kRedColor),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                GestureDetector(
                  onTap: _launchURL,
                  child: Image.asset(
                    'assets/images/digithup.png', // On click should redirect to an URL
                    width: 100.0,
                    height: 75.0,
                    fit: BoxFit.cover,
                  ),
                )


              ],

            ),


    );
  }


}

_launchURL() async {
  const url = 'https://digithup.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}