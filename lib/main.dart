import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/services/local_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
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
  await appRouter.initialize(prefs);
  var router = appRouter.router;

  runApp(MainApp(router: router, prefs: prefs));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.router, required this.prefs});

  final GoRouter router;
  final SharedPreferences prefs;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocalStorageService(widget.prefs),
        ),
      ],
      child: MaterialApp.router(
        title: "Gregtext",
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        routerConfig: widget.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
