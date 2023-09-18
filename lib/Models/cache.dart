import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const kUser = 'isLoggedIn';
  static const kOnboarding = 'onboarding';
  static const gametag = 'games';
  static const imagestag = 'images';
  static const lattag = 'lat';
  static const lontag = 'lon';
  static const leveltag = 'level';
  static const placetag = 'place';
  static const steamidtag = 'steamid';
  static const birthday = 'birthday';
  static const gender = 'gender';
  static const email = 'email';

  static Future<void> removeAll() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> invalidate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kUser, false);
    await prefs.setBool(kOnboarding, false);
  }

  static Future<void> cacheUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kUser, true);
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboarding, true);
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kUser) ?? false;
  }

  static Future<bool> didCompleteOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kOnboarding) ?? false;
  }

  static Future<void> cacheGame(game) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(gametag, List<String>.from(game as List));
  }

  static Future<List<String>> games() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(gametag) ?? [];
  }

  static Future<void> cacheImages(images) async {
    print(images);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(imagestag, List<String>.from(images as List));
  }

  static Future<List<String>> images() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(imagestag) ?? [];
  }

  static Future<void> cacheLat(lat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lattag, lat);
  }

  static Future<String> lat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lattag) ?? "0";
  }

  static Future<void> cacheLon(lon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lontag, lon);
  }

  static Future<String> lon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lontag) ?? "0";
  }

  static Future<void> cacheLevel(level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(leveltag, level);
  }

  static Future<String> level() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(leveltag) ?? "0";
  }

  static Future<void> cachePlace(place) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(placetag, place);
  }

  static Future<String> place() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(placetag) ?? "default";;
  }

  static Future<void> cacheSteamId(steamid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(steamidtag, steamid);
  }

  static Future<String> steamid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(steamidtag) ?? "0";
  }

  static Future<void> cacheBirthday(birthday) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(birthday, birthday);
  }

  static Future<String> Birthday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(birthday) ?? "0";
  }

  static Future<void> cacheEmail(email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(email, email);
  }

  static Future<String> Email() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(email) ?? "0";
  }

  static Future<void> cacheGender(gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(gender, gender);
  }

  static Future<String> Gender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(gender) ?? "Undefined";
  }

}