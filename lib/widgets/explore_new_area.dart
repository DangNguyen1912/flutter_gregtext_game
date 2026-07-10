import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/models/user/game_user.dart';
import 'package:flutter_gregtext_game/services/database_service.dart';
import 'package:provider/provider.dart';

class ExploreNewArea extends StatefulWidget {
  const ExploreNewArea({super.key});

  @override
  State<ExploreNewArea> createState() => _ExploreNewAreaState();
}

class _ExploreNewAreaState extends State<ExploreNewArea> {
  bool isLoading = true;
  Duration timeLeft = Duration();
  GameUser? gameUser;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final db = context.watch<DatabaseService>();
    await Future.delayed(Duration(seconds: 1));
    final user = await db.getUser();
    if (user != null) {
      setState(() {
        gameUser = user;
        isLoading = false;
        if (user.newAreaFinishTime != null) {
          timeLeft = user.newAreaFinishTime!.difference(DateTime.now());
        }
      });
    }
  }

  Future<void> _exploreNewArea() async {
    // TODO: exploreDurarion = time
    // newAreaFinishTime = now add time
  }

  // TODO: time left count down

  // TODO: Done function/button

  double _linearProgressIndicator() {
    return (1 - (timeLeft.inSeconds / gameUser!.exploreDurarion.inSeconds));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explore New Area ${timeLeft.inSeconds == 0 ? ': Task Done' : ''}',
            ),
            gameUser == null
                ? ElevatedButton(
                    onPressed: _exploreNewArea,
                    child: Text('Explore'),
                  )
                : Text(''),
          ],
        ),
        LinearProgressIndicator(
          value: gameUser != null
              ? null
              : timeLeft.inSeconds == 0
              ? null
              : _linearProgressIndicator(),
        ),
      ],
    );
  }
}
