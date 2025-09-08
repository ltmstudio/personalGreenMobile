import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await initLocator();

  } catch (e) {
    debugPrint(e.toString());
  }
  runApp(const AppStart());
}
