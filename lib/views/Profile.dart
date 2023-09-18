import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'search.dart';
import '../controller/request.dart';
import 'bottommenu.dart';
import '../controller/CRUD.dart';
import 'AuthPage.dart';
import '../Models/user.dart';
import '../Models/cache.dart';
import 'package:simple_tags/simple_tags.dart';
import '../Models/cache.dart';

class HomePage extends StatefulWidget {
  final String? steamid;
  final bool? profile;
  const HomePage({Key? key, this.steamid, this.profile}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var favorite_icon=false;

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

  @override
  Widget build(BuildContext context) {
      getRequest(["yyyy"],"76561198017051588","1997-08-07","Male","eraydura@hotmail.com");
      return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: Floating(context,widget.profile==true ? "main" : "return"),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Button(context,widget.profile==true ? "main" : "return"),
        body: FutureBuilder<List<User>?>(
            future:  getUser(widget.profile==true ? AppCache.steamid() : widget.steamid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: <Widget>[
                    SizedBox.expand(
                      child: Image.network(
                          snapshot.data![0].image,
                          fit:BoxFit.cover

                      ),
                    ),
                    DraggableScrollableSheet(
                      minChildSize: 0.1,
                      initialChildSize: 0.22,
                      builder: (context, scrollController){
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //for user profile header
                                Container(
                                  padding : EdgeInsets.only(left: 10, right: 32, top: 32, bottom:5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Stack(
                                              children: [

                                                Container(
                                                  height: 100,decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(16.0),
                                                ),),
                                                Align(
                                                    alignment: Alignment.topCenter,
                                                    child: SizedBox(
                                                      child: CircleAvatar(
                                                        radius: 40.0,
                                                        backgroundColor: Colors.white,
                                                        child:GestureDetector(
                                                          onTap: () {
                                                            print("şsşsş");
                                                          },
                                                          child:  CircleAvatar(
                                                                    child: Align(
                                                                      alignment: Alignment.bottomRight,
                                                                      child: widget.profile==true ? CircleAvatar(
                                                                        backgroundColor: Colors.white,
                                                                        radius: 15.0,
                                                                        child:                                                                 InkWell(
                                                                          hoverColor: Colors.red,
                                                                          onTap: () {

                                                                          },
                                                                          child: Container(
                                                                            width:50,
                                                                            height:50,
                                                                            padding: EdgeInsets.all(1),
                                                                            child: Icon(
                                                                                Icons.edit,
                                                                                color: Colors.deepPurple
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ): Container(),
                                                                    ),
                                                                    radius: 40.0,

                                                                    backgroundImage: NetworkImage(
                                                                        snapshot.data![0].image,

                                                                    ),
                                                              ),
                                                        ),
                                                      ),)
                                                ),
                                              ]
                                          )
                                      ),
                                      SizedBox(width:20),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(snapshot.data![0].full_name, style: TextStyle(color: Colors.grey[800], fontFamily: "Roboto",
                                                fontSize: 25, fontWeight: FontWeight.w700
                                            ),),
                                            Text(snapshot.data![0].email, style: TextStyle(color: Colors.grey[500], fontFamily: "Roboto",
                                                fontSize: 16, fontWeight: FontWeight.w400
                                            ),),
                                            Row(
                                                children: <Widget>[
                                                  Icon(snapshot.data![0].gender=="male" ? Icons.male : Icons.female, color: Colors.deepPurple, size: 35,),
                                                  const VerticalDivider(
                                                    width: 20,
                                                    thickness: 1,
                                                    indent: 20,
                                                    endIndent: 0,
                                                    color: Colors.grey,
                                                  ),
                                                  Text((DateTime.now().year-int.parse(snapshot.data![0].birthday.split("-")[0])).toString() + " years old", style: TextStyle(color: Colors.grey[500],
                                                      fontFamily: "Roboto", fontSize: 16
                                                  ),),
                                                ]
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async{
                                          if(widget.profile==true){
                                            AppCache.removeAll();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => AuthPage())
                                            );
                                          }else{

                                          }
                                        },
                                        child: Icon(widget.profile==true ? Icons.logout : Icons.sms, color: favorite_icon==true ? Colors.red : Colors.deepPurple, size: 40,),
                                      ),
                                    ],
                                  ),
                                ),

                                //performace bar

                                SizedBox(height: 16,),
                                Container(
                                  padding: EdgeInsets.all(32),
                                  color: Colors.deepPurple,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.videogame_asset, color: Colors.white, size: 30,),
                                              SizedBox(width: 4,),
                                              Text(hours((( snapshot.data![0].playtime.reduce((a, b) => a + b) / snapshot.data![0].playtime.length).round()).toString()), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,
                                                  fontFamily: "Roboto", fontSize: 24
                                              ),)
                                            ],
                                          ),

                                          Text("average played games", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,
                                              fontFamily: "Roboto", fontSize: 15
                                          ),)
                                        ],
                                      ),

                                      Column(
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.star, color: Colors.white, size: 30,),
                                              SizedBox(width: 4,),
                                              Text(snapshot.data![0].level, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,
                                                  fontFamily: "Roboto", fontSize: 24
                                              ),)
                                            ],
                                          ),

                                          Text("Level", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,
                                              fontFamily: "Roboto", fontSize: 15
                                          ),)
                                        ],
                                      ),


                                    ],
                                  ),
                                ),

                                SizedBox(height: 16,),

                                Container(
                                  padding: EdgeInsets.only(left: 32, right: 32),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child:Text("Game Tags", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700,
                                            fontFamily: "Roboto", fontSize: 25
                                        ),),
                                      ),


                                      SizedBox(height: 8,),
                                      SimpleTags(
                                        content: snapshot.data![0].tags.split(','),
                                        wrapSpacing: 4,
                                        wrapRunSpacing: 4,
                                        tagContainerPadding: EdgeInsets.all(10),
                                        tagTextStyle: TextStyle(color: Colors.white,fontSize:18),
                                        tagContainerDecoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(139, 139, 142, 0.16),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(1.75, 3.5), // c
                                            )
                                          ],
                                        ),
                                      ),
                                     ],
                                  ),
                                ),


                                SizedBox(height: 16,),
                                //Container for clients

                                Container(
                                  padding: EdgeInsets.only(left: 2, right: 2),
                                  child: Column(
                                    children: <Widget>[
                                      Text("Games", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto", fontSize: 25
                                      ),),

                                      SizedBox(height: 8,),
                                      //for list of clients
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 220,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data![0].games.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: 250,
                                              height: 200,
                                              margin: EdgeInsets.only(right: 18),
                                              child:  Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                        Center(
                                                                  child:
                                                                        ClipOval(child: Image.network(snapshot.data![0].imagesurl[index].toString(), width:120,height:120, fit: BoxFit.cover,),),
                                                        ),
                                                        SizedBox(height:10),
                                                      Center(
                                                        child:
                                                                Text(snapshot.data![0].games[index].toString(), style: TextStyle(color: Colors.grey[800], fontFamily: "Roboto",
                                                                    fontSize: 18, fontWeight: FontWeight.w700
                                                                ),),
                                                      ),
                                                    Center(
                                                      child:Text(hours(snapshot.data![0].playtime[index].toString()).toString(), style: TextStyle(color: Colors.grey[700], fontFamily: "Roboto",
                                                          fontSize: 15, fontWeight: FontWeight.w400
                                                      ),),
                                                    )

                                                  ],
                                               ),
                                             );
                                           },
                                          shrinkWrap: true,
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                                SizedBox(height: 16,),




                              ],
                            ),

                          ),
                        );
                      },
                    )
                  ],
                );
              }
              else {
                return Center(
                  child:CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                      strokeWidth: 3
                  ),
                );
              }
            }
        ),
      );
    }



}




