import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/services/local_storage_service.dart';
import 'package:provider/provider.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<LocalStorageService>().getProfiles();

    return Scaffold(
      appBar: AppBar(title: Text("profile Selection")),
      body: Column(
        children: [
          Text("select profile that you want to play"),
          Expanded(
            child: ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (BuildContext context, int index) {
                var profile = profiles[index];
                Text("body");
                return;
              },
            ),
          ),
          Text("tail"),
        ],
      ),
    );
  }
}
