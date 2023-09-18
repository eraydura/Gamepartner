import 'package:flutter/material.dart';
import 'Profile.dart';
import 'package:http/http.dart' as http;
import '../controller/CRUD.dart';
import 'package:firebase_core/firebase_core.dart';
import '../controller/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/cache.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'tags.dart';
import '../Models/user.dart';

class AuthPage extends StatefulWidget{
  const AuthPage({Key? key}): super(key: key);

  @override
  State<AuthPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthPage>{
  TextEditingController emailcon = TextEditingController();
  TextEditingController passcon = TextEditingController();
  TextEditingController email2con = TextEditingController();
  TextEditingController birthdaycon = TextEditingController();
  TextEditingController idcon = TextEditingController();
  TextEditingController pass2con = TextEditingController();
  TextEditingController pass3con = TextEditingController();
  var login=true;
  DateTime selectedDate = DateTime.now();
  bool isMan = false, isWoman = false;
  String steamid = "" , password = "", pass = "", pass2 = "", email = "", mail = "", gender = "";
  bool steamid_valid = false , password_valid = false, pass_valid = false, pass2_valid = false, email_valid = false, mail_valid = false, birthday_valid = false;

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  Future<void> singin() async {
      try {

        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        UserCredential userCredential = await FirebaseAuth
            .instance
            .signInWithEmailAndPassword(
            email: email, password: password);

        var steamid=await getId(email);
        AppCache.cacheUser();
        AppCache.cacheSteamId(steamid);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(steamid:steamid.toString(),profile:true),)
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showAlertDialog(context,'No user found for that email.',false);
        } else if (e.code == 'wrong-password') {
          showAlertDialog(context,'Wrong password provided for that user.',false);
        }
      }
  }

  showAlertDialog(BuildContext context,text, info) {
      showDialog(context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: info!=true ? 220 : 600,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.deepPurple
                    ),
                    padding: EdgeInsets.fromLTRB(20, 150, 20, 0),
                    child: Text(info!=true ? text : "1. Open the Steam application on your Mac or PC and log in. \n\n"
                        "2. Open your profile by clicking the button at the top of the screen — it's your profile name in big letters. \n \n"
                        "3. You should see a URL appear below the button. Your Steam ID is the long string of numbers in that URL. \n \n"
                        "https://steamcommunity.com/profiles/xxxxxxxxxxxxxxxxx",
                        style: TextStyle(fontSize: 24,color:Colors.white),
                        textAlign: TextAlign.center
                    ),
                  ),
                  Positioned(
                      top: 20,
                      child: Image.network(info==true ? "https://i.imgur.com/2yaf2wb.png" : "https://cdn-icons-png.flaticon.com/512/260/260250.png"  , width: 100, height: 100)
                  )
                ],
              )
          );
        },);

  }

  Future<void> logined() async{

    try {

      String url = "https://api.steampowered.com/IPlayerService/GetSteamLevel/v1/?key=42EE25AE1C1B419F64B0015DC3DF0E14&steamid="+steamid;
      final response = await http.get(Uri.parse(url));
      var responseData = json.decode(response.body);

      if(isWoman){
        gender = "Woman";
      }else if(isMan){
        gender = "Male";
      }else{
        gender = "Undefined";
      }


      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      UserCredential userCredential = await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(
          email: mail, password: pass);

      AppCache.cacheUser();
      AppCache.cacheSteamId(steamid);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InputChipExample(steamid:steamid, birthday:selectedDate.toString().split(' ')[0], gender:gender, email:mail)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showAlertDialog(context,'The account already exists for that email.',false);
      }
    } catch (e) {
      setState(() {
        steamid_valid = true;
      });
    }


  }



  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: login ? Login() : Signin()
        )
      )
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked.toLocal();
      });
    }
  }

  Widget Login(){
    return SingleChildScrollView(
        child:Column(

        children:[
          Image(image:
          AssetImage(
            'assets/images/logo2.png',
          ),
            fit: BoxFit.cover,
            width: 200,
          ),

          SizedBox(height:55),

          Text(
            'Hello,again!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:24,
            ),
          ),
          SizedBox(height:10),
          Text(
            'Welcome back, we\'ve missed you',
            style: TextStyle(
              fontSize:20,
            ),
          ),
          SizedBox(height:20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child:Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child:TextFormField(
                  controller:emailcon,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:'E-mail',
                    errorText: email_valid ? 'Value is not correct. Try again' : null,
                  ),
                  onChanged: (text) {
                    setState(() {
                      email = text;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height:10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child:Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child:TextFormField(
                  obscureText:true,
                  controller:passcon,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:'Password',
                    errorText: password_valid ? 'Value is not correct. Try again' : null,
                  ),
                  onChanged: (text) {
                    setState(() {
                      password = text;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height:10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child: Container(
                padding: EdgeInsets.all(20.0),
                decoration:BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:Center(
                    child:TextButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:18,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          (email.isEmpty || isEmail(email)==false ) ? email_valid = true : email_valid = false;
                          (password.isEmpty || password.length<6) ? password_valid = true : password_valid = false;
                        });
                        if(email_valid == false && password_valid == false){
                          singin();
                        }
                      },
                    ),
                )
            ),
          ),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text(
                    'Not a member ?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused))
                            return Colors.red;
                          return Colors.grey; // Defer to the widget's default.
                        }
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      login=false;
                    });
                  },
                  child: Text(
                      ' Register',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                )
              ]
          )
        ]
    ),
    );
  }

  Widget Signin(){
    return SingleChildScrollView(
        child:Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Image(image:
          AssetImage(
            'assets/images/logo.png',
          ),
            fit: BoxFit.contain,
            width: 140,
          ),

          SizedBox(height:20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child:Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: TextFormField(
                  controller:email2con,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:'E-mail',
                    errorText: mail_valid ? 'Value is not correct. Try again' : null,
                  ),

                  onChanged: (text) {
                    setState(() {
                      mail = text;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child:Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child:TextFormField(
                      controller:birthdaycon,
                      readOnly: true,
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:"${selectedDate.toLocal()}".split(' ')[0],
                        errorText: birthday_valid ? 'Your Age must be more than 10' : null,
                      ),
                  onTap: () => _selectDate(context),

                ),
                  ),
                ),
              ),

          SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.only(left:100.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "Man:",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.grey),
                  child: Checkbox(
                    value: isMan,
                    checkColor: Colors.deepPurple,
                    activeColor: Colors.white,
                    onChanged: (value) {
                      setState(
                            () {
                          isMan = value!;
                          isWoman = false;
                        },
                      );
                    },
                  ),
                ),
                Text(
                  "Woman:",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.grey),
                  child: Checkbox(
                    value: isWoman,
                    checkColor: Colors.deepPurple,
                    activeColor: Colors.white,
                    onChanged: (value) {
                      setState(
                            () {
                          isWoman = value!;
                          isMan = false;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:25.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child:TextFormField(
                  controller:idcon,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: new Icon(Icons.info, color: Colors.deepPurple),
                      highlightColor: Colors.pink,
                      onPressed: (){
                        showAlertDialog(context,"lllxl",true);
                      },
                    ),
                    hintText:'Steam User Id',
                    errorText: steamid_valid ? 'Value is not correct. Try again' : null,
                  ),
                  maxLength: 17,
                  onChanged: (text) {
                    setState(() {
                      steamid = text;
                    });
                  },
                ),
              ),
            ),
        ),

          SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child:Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child:TextFormField(
                  controller:pass2con,
                  obscureText:true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:'Password',
                    errorText: pass_valid ? 'Value is not correct. Try again' : null,
                  ),
                  onChanged: (text) {
                    setState(() {
                      pass = text;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height:10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child:Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:20.0),
                child:TextFormField(
                  controller:pass3con,
                  obscureText:true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:'Password Again',
                    errorText: pass2_valid ? 'Value is not correct. Try again' : null,
                  ),
                  onChanged: (text) {
                    setState(() {
                      pass2 = text;
                    });

                  },
                ),
              ),
            ),
          ),
          SizedBox(height:10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            child: Container(
                padding: EdgeInsets.all(10.0),
                decoration:BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:Center(
                    child:TextButton(
                      child: Text(
                                'Sign In',
                                style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:18,
                          ),
                      ),
                      onPressed: () {

                        setState(() {
                          (mail.isEmpty || isEmail(mail)==false ) ? mail_valid = true : mail_valid = false;
                          (pass.isEmpty || pass.length<6) ? pass_valid = true : pass_valid = false;
                          (pass2.isEmpty || pass2.length<6 || pass2!=pass) ? pass2_valid = true : pass2_valid = false;
                          ((DateTime.now().year-int.parse(selectedDate.toString().split("-")[0]))<10  ) ? birthday_valid = true : birthday_valid = false;
                          (steamid.isEmpty && steamid.length!=17) ? steamid_valid = true : steamid_valid = false;
                        });
                        if(mail_valid == false && pass_valid == false && pass2_valid == false && birthday_valid == false && steamid_valid == false){
                          logined();
                        }

                      },
                    ),
                )

            ),
          ),

          SizedBox(height: 10),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text(
                    'You\'re already a member ?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused))
                            return Colors.red;
                          return Colors.grey; // Defer to the widget's default.
                        }
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      login=true;
                    });
                  },
                  child: Text(
                      ' Sign in',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      )
                  ),

                )
              ]
          )


        ]
    ),
    );
  }

}

