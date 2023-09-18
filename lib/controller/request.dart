import 'package:http/http.dart' as http;
import '../Models/user.dart';
import 'dart:convert';
import 'CRUD.dart';
import '../Models/cache.dart';


Future<List<User>> getRequest(tags,steamid,birthday,gender,email)  async {

  String url = "https://api.steampowered.com/IPlayerService/GetSteamLevel/v1/?key=42EE25AE1C1B419F64B0015DC3DF0E14&steamid="+steamid;
  final response = await http.get(Uri.parse(url));
  var responseData = json.decode(response.body);

  String url2 = "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=42EE25AE1C1B419F64B0015DC3DF0E14&steamids="+steamid;
  final response2 = await http.get(Uri.parse(url2));
  var responseData2 = json.decode(response2.body);

  String url3 = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=42EE25AE1C1B419F64B0015DC3DF0E14&steamid="+steamid+"&include_appinfo=true&include_played_free_games=true&include_free_sub=false&skip_unvetted_apps=false&include_extended_appinfo=false";
  final response3 = await http.get(Uri.parse(url3));
  var responseData3 = json.decode(response3.body);

  String name=responseData2["response"]["players"][0]["personaname"];
  String level=responseData["response"]["player_level"].toString();
  String image=responseData2["response"]["players"][0]["avatarfull"].toString();

  List games= [];
  List playtime = [];
  List imagesurl = [];
  for (var game in responseData3["response"]["games"]) {
    games.add(game["name"]);
    playtime.add(game["playtime_forever"]);
    imagesurl.add('https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/'+game["appid"].toString()+'/'+game["img_icon_url"].toString()+'.jpg');
  }

  AppCache.cacheGame(games);
  AppCache.cacheImages(imagesurl);
  AppCache.cacheLevel(level);

  var lat;
  var lon;
  var place;

  await AppCache.lat().then((String result){
    lat=result;
  });

  await AppCache.lon().then((String result){
    lon=result;
  });

  await AppCache.place().then((String result){
    place=result;
  });

  List<User> users = [];
  User user = User(
    full_name: name,
    level: level,
    email:email,
    gender:gender,
    tags:tags.toString().substring( 1, tags.toString().length -1 ),
    birthday:birthday,
    games: games,
    playtime: playtime,
    imagesurl: imagesurl,
    image: image,
    steamid:steamid,
    online: true,
    location:place,
    lat: lat,
    lon: lon
  );

  addUser(name,email,tags,birthday,gender,games,imagesurl,playtime,true,level,image,steamid,place,lat, lon);

  users.add(user);
  return users;
}

Future<String> game(steamid) async{
  if(steamid is Future<String>){
    await steamid.then((String steamid2){
      steamid=steamid2;
    });
  }
  String url ="https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?steamid="+steamid+"&include_appinfo=1&include_played_free_games=1&key=42EE25AE1C1B419F64B0015DC3DF0E14&format=json";
  final response = await http.get(Uri.parse(url));
  var responseData = json.decode(response.body);
  if(responseData["response"]["total_count"]==0){
    return "0";
  }else{
    return responseData["response"]["games"][0]["name"];
  }

}

Future<String> gameimage(game) async{
  List<String> games2=[];
  List<String> images2=[];
  await AppCache.games().then((List<String> games){
      games2=games;
  });
  await AppCache.images().then((List<String> images){
      images2=images;
  });
  return images2[games2.indexOf(game)];
}