import 'package:firebase_core/firebase_core.dart';
import '../controller/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../controller/request.dart';
import 'dart:convert';
import '../Models/user.dart';
import '../Models/cache.dart';

CollectionReference users = FirebaseFirestore.instance.collection('Users');

Future<void> connection() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> addUser(name,email,tags,birthday,gender,games,imagesurl,playtime,online,level,image,steamid,location,lat, lon) async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  return users.doc(steamid).set({
    'full_name': name,
    'online': online,
    'games': games,
    'tags': tags,
    'email': email,
    'birthday': birthday,
    'gender' :gender,
    'playtime': playtime,
    'imagesurl': imagesurl,
    'level' : level,
    'image' : image,
    'steamid' : steamid,
    'location' : location,
    'lat' :lat,
    'lon' :lon
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}


Future<List<User>> getAllData() async {


  List<User> getusers = [];
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var data = await users.get();
  final allData = data.docs.map((doc) => doc.data()).toList();

  for (var element in allData) {
    var data=User.fromJson(element as Map<String, dynamic>);
    var level="0";
    var steamid="0";
    var place="0";

    await AppCache.level().then((String result){
      level=result;
    });

    await AppCache.steamid().then((String result){
      steamid=result;
    });

    await AppCache.place().then((String result){
      place=result;
    });
    String recentgame= await game(steamid);

    if( data.steamid!=steamid && data.online==true && data.games.contains(recentgame) && data.location==place ) {
      getusers.add(data);
    }
  }

  return getusers.toList();
}

Future<List<User>> getUser(steamid) async {

  List<User> getuser = [];
  String cachesteamid="";

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if(steamid is Future<String>){
    await steamid.then((String steamid2){
      cachesteamid=steamid2;
    });
  }else{
    cachesteamid=steamid;
  }

  var data = await users.get();
  final allData = data.docs.map((doc) => doc.data()).toList();
  for (var element in allData) {
    var data=User.fromJson(element as Map<String, dynamic>);
    if(data.steamid==cachesteamid ) {
      getuser.add(data);
      break;
    }
  }
  return getuser.toList();
}

Future<String> getId(email) async {
  String steamid="";

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var data = await users.get();
  final allData = data.docs.map((doc) => doc.data()).toList();
  for (var element in allData) {
    var data=User.fromJson(element as Map<String, dynamic>);
    if(data.email==email ) {
      steamid=data.steamid;
      AppCache.cacheImages(data.imagesurl.toString().split(","));
      AppCache.cacheGame(data.games);
      AppCache.cacheLevel(data.level);
      break;
    }
  }
  return steamid;
}

Future<void> changeStatus(status,steamid2) async{
  var steamid="";

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await steamid2.then((String steamid2){
    steamid=steamid2;
  });

  if(status=="closed"){
    users.doc(steamid).update({
      'online':false
    });
  }else{
    users.doc(steamid).update({
      'online':true
    });
  }

}

Future<void> changetag(tags,steamid2) async{
  var steamid="";
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await steamid2.then((String steamid2){
    steamid=steamid2;
  });
  users.doc(steamid).update({
    'tags':tags
  });
}

Future<double> calculateDistance(lat, lon, lat2, lon2) async{
  var lat1;
  var lon1;

  await lat.then((String result){
    lat1=double.parse(result);
  });


  await lon.then((String result){
    lon1=double.parse(result);
  });

  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return (12742 * asin(sqrt(a))).floorToDouble();
}

Future<int> compactible(games) async{
  double compatible=0;
  await AppCache.games().then((List<String> result){
    for (var i = 0; i < games.length; i++) {
      if(result.contains(games[i])){
        compatible=compatible+1;
      }
    }
    if(compatible!=0){
      compatible=(compatible/(result.length))*100;
    }
  });
  return compatible.toInt();

}

String hours(hour){
  double days=double.parse(hour)/24;
  double hours=double.parse(hour)-(double.parse(days.toString().split(".")[0])*24);

  return hours.toString().split(".")[0]=="0" ? "Not played": days.toString().split(".")[0]+" d " +hours.toString().split(".")[0]+" h" ;
}

int maxplayed( list ){
  int max=0;
  for(var number in list.split(", ")){
    if(int.parse(number)>max){
      max=int.parse(number);
    }
  }
  final notes = list.split(", ");
  return notes.indexOf(max.toString());
}

Future<List<types.Message>> getChats(steamid,steamid2) async {
  List<dynamic> jsonData=[];

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CollectionReference chats = FirebaseFirestore.instance.collection('Users/'+steamid+'/chats');
  var data = await chats.doc(steamid2).get();
  if (data.exists) {
    for (var element in data["history"].reversed.toList()) {
      var user = types.User(id: element["id"],firstName:"Eray Dura", imageUrl: element["image"],);
      var message = types.TextMessage(author: user, id: steamid2,createdAt: int.parse(element["date"]), text: element["text"]);
      jsonData.add(message.toJson());
    }
  }
  final messages = jsonData.map((e) => types.Message.fromJson(e as Map<String, dynamic>)).toList();

  return messages;
}

Future<void> getupdateChats(steamid,steamid2,chat,date) async {
  List<Map<String,dynamic>> history=[];

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CollectionReference chats = FirebaseFirestore.instance.collection('Users/'+steamid+'/chats');
  var data = await chats.doc(steamid2).get();

  try{

    for (var element in data["history"]) {
      history.add(element);
    }
    final Map<String, String> someMap = {
      "id": steamid,
      "date": date.toString(),
      "text": chat,
      "image":"https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d"
    };
    history.add(someMap);

    chats.doc(steamid2).update({
      'history':history
    });

  }catch(e){

    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection('Users/'+steamid+'/chats').doc(steamid2);

    final Map<String, String> someMap = {
      "id": steamid,
      "date": date.toString(),
      "text": chat,
      "image":"https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d"
    };
    history.add(someMap);

    chats.doc(steamid2).update({
      'history':history
    });

  }


}