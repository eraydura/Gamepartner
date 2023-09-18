import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Profile.dart';
import 'search.dart';
import '../Models/cache.dart';

Future<void> profile(context) async{
  await AppCache.steamid().then((String steamid2){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => HomePage(steamid: steamid2, profile: true)),
    );
  });
}
Widget Button(context,page){
  return BottomAppBar(
    color: Colors.deepPurple,
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(
              Icons.person,
              color: Colors.white,
              size:35,
          ),
          onPressed:  (){
            if(page!="main"){
                 profile(context);
              };
            }
        ),
        IconButton(
          icon: Icon(
              Icons.message,
              color: Colors.white,
              size:35,
          ),
          onPressed: () {

          },
        ),

      ],
    ),
  );
}

Widget Floating(context,page){
  return FloatingActionButton(
    onPressed:  () {
      if(page!="search") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LocationPage(),
          ),
        );
      }
    },
    child: Icon(
      Icons.search,
      color: Colors.white,
      size:35,
    ),
    backgroundColor: Colors.deepPurple,
  );
}