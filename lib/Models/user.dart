import 'dart:convert';

class User {
  final String full_name;
  final String level;
  final String image;
  final String birthday;
  final String email;
  final String gender;
  final bool online;
  final List games;
  final String tags;
  final List playtime;
  final List imagesurl;
  final String steamid;
  final String location;
  final String lat;
  final String lon;

  User({
    required this.full_name,
    required this.level,
    required this.games,
    required this.tags,
    required this.playtime,
    required this.image,
    required this.gender,
    required this.email,
    required this.birthday,
    required this.imagesurl,
    required this.steamid,
    required this.online,
    required this.location,
    required this.lat,
    required this.lon,
  });

  factory User.fromJson(Map<String, dynamic> snapshot) {
    return User(
        full_name : snapshot['full_name'] ?? '',
        image : snapshot['image'] ?? '',
        birthday: snapshot['birthday'] ?? '',
        gender: snapshot['gender'] ?? '',
        email: snapshot['email'] ?? '',
        tags: snapshot['tags'].toString().split('[')[1].split(']')[0] ?? '',
        games : snapshot['games']  ?? '',
        playtime : snapshot['playtime']  ?? '',
        imagesurl : snapshot['imagesurl']  ?? '',
        lat : snapshot['lat'] ?? '',
        lon : snapshot['lon'] ?? '',
        location : snapshot['location'] ?? '',
        level : snapshot['level'] ?? '',
        online :snapshot['online'] ?? '',
        steamid : snapshot['steamid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
        return {
            "full_name": full_name,
            "games": games,
            "tags": tags,
            "birthday": birthday,
            "gender": gender,
            "email": email,
            "playtime": playtime,
            "imagesurl": imagesurl,
            "image": image,
            "lon": lon,
            "lat": lat,
            "location": location,
            "level": level,
            "online": online,
            "steamid":steamid,
        };
    }


}