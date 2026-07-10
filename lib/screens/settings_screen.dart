import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/services/database_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _updateGameUser() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    var user = await db.getUser();
    if (user != null) {
      db.saveUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _updateGameUser,
              child: Text('Update game user'),
            ),
          ],
        ),
      ),
    );
  }
}
