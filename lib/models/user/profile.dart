// ignore_for_file: public_member_api_docs, sort_constructors_first
// ProfileIds = UserIds
// this is use to select profiles/users without loading inventories and heavy stuff, just ids, names and info stuff

class Profile {
  String profileId;
  String profileName;
  DateTime createDate;
  DateTime playedTime;
  int gameStage;

  Profile({
    required this.profileId,
    required this.profileName,
    required this.createDate,
    required this.playedTime,
    required this.gameStage,
  });
}
