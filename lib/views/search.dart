import 'package:flutter/material.dart';
import 'Profile.dart';
import '../controller/CRUD.dart';
import 'dart:convert';
import '../Models/user.dart';
import 'bottommenu.dart';
import '../controller/request.dart';
import '../Models/cache.dart';
import 'dart:math';


class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>  with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.paused == state) {
      changeStatus("closed",AppCache.steamid());
    }else{
      changeStatus("opened",AppCache.steamid());
    }
  }
  var index2=0;
  var searching=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: Floating(context,"search"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Button(context,"search"),
      body: SafeArea(
        child: Center(
          child: searching!=true ?
                 Container(
                    child: FutureBuilder(
                        future: game(AppCache.steamid()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data.toString()!="0" ?
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  searching=true;
                                });
                              },
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text("Recently Playing", style: TextStyle(color:Colors.deepPurple, fontWeight: FontWeight.bold, fontSize:30)),
                                  SizedBox(height:20),
                                  FutureBuilder(
                                    future: gameimage(snapshot.data.toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return CircleAvatar(
                                          radius: 150,
                                          backgroundImage: NetworkImage(
                                              snapshot.data.toString().trim() ),
                                        );
                                      }else{
                                        return CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                                            strokeWidth: 3
                                        );
                                      }
                                    }
                                  ),
                                  SizedBox(height:20),
                                  Text(snapshot.data.toString(), style: TextStyle(color:Colors.deepPurple, fontWeight: FontWeight.bold, fontSize:25)),
                                  Text("Click to find the game partner", style: TextStyle(color:Colors.deepPurple, fontWeight: FontWeight.bold, fontSize:15)),
                                ]
                              )
                            ): Container() ;
                          } else {
                            return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                                strokeWidth: 3
                            );
                          }
                        }
                    ),
                 )
              :
          FutureBuilder<List<User>?>(
                    future: getAllData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        if(snapshot.data!.length>0){
                          return  Container(
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      child: Column(
                                          children: [
                                            SizedBox(
                                              height: 430,
                                              width: MediaQuery.of(context).size.width,
                                              child:Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: 310),
                                                  child:  ListView.builder(
                                                    itemCount: snapshot.data!.length,
                                                    itemBuilder: (ctx, index) => ListTile(

                                                      title: Container(
                                                        padding: EdgeInsets.all(32),
                                                        color: Colors.deepPurple,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            FutureBuilder(
                                                                future: calculateDistance(AppCache.lat(),AppCache.lon(),double.parse(snapshot.data![index2].lat),double.parse(snapshot.data![index2].lon)),
                                                                builder: (context, snapshot) {
                                                                  if (snapshot.hasData) {
                                                                    return Vertical2("Distance", snapshot.data.toString() + " KM",null);
                                                                  } else {
                                                                    return Text('Loading');
                                                                  }
                                                                }
                                                            ),
                                                            FutureBuilder(
                                                                future: compactible(snapshot.data![index2].games),
                                                                builder: (context, snapshot) {
                                                                  if (snapshot.hasData) {
                                                                    return Text(snapshot.data.toString() + "%",style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize:25));
                                                                  } else {
                                                                    return Text('Loading');
                                                                  }
                                                                }
                                                            ),
                                                            Vertical2("City", snapshot.data![index2].location,null),

                                                          ],
                                                        ),
                                                      ),
                                                      contentPadding: EdgeInsets.only(bottom: 20.0),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 320.00,
                                                    decoration: new BoxDecoration(
                                                      image: new DecorationImage(
                                                        image: NetworkImage(
                                                          snapshot.data![index2].image,
                                                        ),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    )
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(top: 280),
                                                  child:Card(
                                                      semanticContainer: true,
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children:[

                                                                InkWell(
                                                                  hoverColor: Colors.red,
                                                                  onTap: () {

                                                                  },
                                                                  child: Container(
                                                                    width:50,
                                                                    height:50,
                                                                    padding: EdgeInsets.all(1),
                                                                    child: Icon(
                                                                      Icons.mail,
                                                                      size: 36.0,
                                                                      color:  Colors.deepPurple,
                                                                    ),
                                                                  ),
                                                                ),


                                                                Text(
                                                                    snapshot.data![index2].full_name,
                                                                    style: TextStyle(
                                                                      fontSize: 40,
                                                                      color: Colors.deepPurple,
                                                                      fontWeight: FontWeight.w500,
                                                                    ), //Textstyle
                                                                ),


                                                                InkWell(
                                                                  hoverColor: Colors.red,
                                                                  onTap: () {
                                                                    Navigator.of(context).push(
                                                                      MaterialPageRoute(
                                                                        builder: (context) => HomePage(steamid: snapshot.data![index2].steamid, profile: false),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    width:50,
                                                                    height:50,
                                                                    padding: EdgeInsets.all(1),
                                                                    child: Icon(
                                                                      Icons.face,
                                                                      color:Colors.deepPurple,
                                                                      size: 36.0,
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],

                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      elevation: 5,
                                                      margin: EdgeInsets.all(10),
                                                    ),
                                                 ),


                                              ],
                                            ),

                                           ),
                                           SizedBox(height:5),
                                           Row(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: <Widget>[
                                                 Vertical2("Most Played", snapshot.data![index2].games[maxplayed(snapshot.data![index2].playtime)], snapshot.data![index2].imagesurl[maxplayed(snapshot.data![index2].playtime)]),
                                               ],
                                             ),

                                          ],
                                        ), //Column
                                    ), //SizedBox
                              );
                        } else {
                          return  Container(
                                child: FutureBuilder(
                                    future: game(AppCache.steamid()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data.toString()!="0" ?
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                searching=true;
                                              });
                                            },
                                            child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children:[
                                                  Text("There is no active people playing", style: TextStyle(color:Colors.deepPurple, fontWeight: FontWeight.bold, fontSize:25)),
                                                  SizedBox(height:20),
                                                  FutureBuilder(
                                                      future: gameimage(snapshot.data.toString()),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return CircleAvatar(
                                                            radius: 150,
                                                            backgroundImage: NetworkImage(
                                                                snapshot.data.toString().trim() ),
                                                          );
                                                        }else{
                                                          return CircularProgressIndicator(
                                                              valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                                                              strokeWidth: 3
                                                          );
                                                        }
                                                      }
                                                  ),
                                                  SizedBox(height:20),
                                                  Text(snapshot.data.toString(), style: TextStyle(color:Colors.deepPurple, fontWeight: FontWeight.bold, fontSize:25)),
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                                              (Set<MaterialState> states) {
                                                            if (states.contains(MaterialState.focused))
                                                              return Colors.red;
                                                            return null; // Defer to the widget's default.
                                                          }
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        searching=true;
                                                      });
                                                    },
                                                    child: Text('Try Again'),
                                                  ),
                                                ]
                                            )
                                        ): Container() ;
                                      } else {
                                        return CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                                            strokeWidth: 3
                                        );
                                      }
                                    }
                                ),
                              );
                        }

                        }

                      /// handles others as you did on question
                      else {
                        return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                            strokeWidth: 3
                        );
                  }
               },
          ),
        ),
      ),
    );
  }
}

Widget Vertical2(text, value,image){
  return MaterialButton(
    padding: EdgeInsets.symmetric(vertical: 4),
    onPressed:(){},
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        (() {
          if(image==null) {
            return Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color:Colors.white ),
            );
          }
          return Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color:Colors.deepPurple ),
          );
        })(),
        SizedBox(height: 2),
        (() {
          if(image!=null){
            return Container();
          }
          return Container();
        })(),
        (() {
        if(image==null) {
          return Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          );
        }
        return Column(
          children:[
            SizedBox(height:5),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40.0,
              backgroundImage: NetworkImage(
                image

              ),
            ),
            SizedBox(height:5),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple),
            )
          ],
        );
        })(),
      ],
    ),
  );
}

