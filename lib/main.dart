import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/services/auth_service.dart';
import 'package:flutter_gregtext_game/services/database_service.dart';
import 'package:flutter_gregtext_game/services/local_storage_service.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (optional, will work without if not available)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase not available: $e');
  }
  Provider.debugCheckInvalidValueType = null;

  var prefs = await SharedPreferences.getInstance();

  var appRouter = AppRouter();
  await appRouter.initialize(prefs, AuthService().hasUser());

  runApp(MainApp(appRouter: appRouter, prefs: prefs));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appRouter, required this.prefs});

  final AppRouter appRouter;
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalStorageService(prefs)),
        ChangeNotifierProvider(create: (_) => DatabaseService()),
      ],
      child: MaterialApp.router(
        title: "Gregtext",
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(primary: Colors.blue),
        ),
        routerConfig: appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
