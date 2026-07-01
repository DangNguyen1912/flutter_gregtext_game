import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/models/user/profile.dart';
import 'package:flutter_gregtext_game/services/local_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<LocalStorageService>().getProfiles();

    return Scaffold(
      appBar: AppBar(title: Text("Profile Selection")),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text("Select profile that you want to play"),
            Expanded(
              child: ListView.builder(
                itemCount: profiles.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < profiles.length) {
                    var profile = profiles[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Action when a profile is selected
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.profileName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Stage ${profile.gameStage}",
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          // TODO: Implement Edit Profile dialog/action
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () async {
                                          // TODO: Confirm dialog
                                          final storageService = context
                                              .read<LocalStorageService>();
                                          List<Profile> updatedList = List.from(
                                            storageService.getProfiles(),
                                          );
                                          updatedList.removeAt(index);
                                          storageService.setProfiles(
                                            updatedList,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                "ID: ${profile.profileId}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Created: ${DateFormat('dd MMM yyyy').format(profile.createDate)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Playtime: "
                                "${profile.playedTime.inSeconds == 0 ? "Never" : "${profile.playedTime.inHours > 0 ? "${profile.playedTime.inHours} hour" : ""} "
                                          "${profile.playedTime.inMinutes % 60 > 0 ? "${profile.playedTime.inHours} minute" : ""} "
                                          "${profile.playedTime.inSeconds % 60 > 0 ? "${profile.playedTime.inHours} second" : ""}"}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                      ),
                      onPressed: () async {
                        var newProfile = await newProfileDialog(context);
                        if (newProfile != null) {
                          context.read<LocalStorageService>().setProfiles(
                            List.from(
                              context.read<LocalStorageService>().getProfiles()
                                ..add(newProfile),
                            ),
                          );
                        }
                      },
                      label: Text(
                        "Create New Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Profile?> newProfileDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  return showDialog<Profile>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(32),
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create new Profile', style: TextStyle(fontSize: 22)),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var newProfile = Profile(
                          profileId: Uuid().v4(),
                          profileName: nameController.text,
                          createDate: DateTime.now(),
                          playedTime: Duration(),
                          gameStage: 0,
                        );
                        context.pop(newProfile);
                      }
                    },
                    child: Text("Create"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
