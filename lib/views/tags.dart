import 'package:flutter/material.dart';
import '../controller/string.dart';
import '../Models/cache.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'Profile.dart';
import '../controller/request.dart';
import '../controller/CRUD.dart';

String? _currentAddress;
Position? _currentPosition;

class InputChipExample extends StatefulWidget {
  final String? steamid;
  final String? birthday;
  final String? gender;
  final String? email;
  const InputChipExample({Key? key, this.steamid, this.birthday, this.gender, this.email}) : super(key: key);

  @override
  State<InputChipExample> createState() => _InputChipExampleState();
}

class _InputChipExampleState extends State<InputChipExample> {
  int? selectedIndex;
  List<int?> selectedicon=[];
  List<String> selectedicontype=[];

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      AppCache.cacheLat( _currentPosition!.latitude.toString());
      AppCache.cacheLon( _currentPosition!.longitude.toString());
      AppCache.cachePlace(place.administrativeArea);
    }).catchError((e) {
      debugPrint(e);
    });

  }
  showAlertDialog(BuildContext context) {
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
                  height: 220 ,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.deepPurple
                  ),
                  padding: EdgeInsets.fromLTRB(20, 150, 20, 0),
                  child: Text( "You must select more than one tag",
                      style: TextStyle(fontSize: 22,color:Colors.white),
                      textAlign: TextAlign.center
                  ),
                ),
                Positioned(
                    top: 20,
                    child: Image.network( "https://cdn-icons-png.flaticon.com/512/260/260250.png"  , width: 100, height: 100)
                )
              ],
            )
        );
      },);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('SELECT YOUR FAVOURITE TYPES', style:TextStyle(
            fontSize:18,
          )),
          actions: <Widget>[
          IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Show Snackbar',
          onPressed: () {
              setState(() {
                selectedIndex=null;
                selectedicon = [];
                selectedicontype=[];
              });
          },
        ),
       ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if(selectedicontype.length>=1){
            await _getCurrentPosition();
            await changetag(selectedicontype,AppCache.steamid());
            await getRequest(selectedicontype, widget.steamid.toString(), widget.birthday.toString(), widget.gender.toString(), widget.email.toString());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(steamid: widget.steamid.toString(), profile: true)),
            );
          }else{
            showAlertDialog(context);
          }

        },
        child: Icon(Icons.done, color:Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 5.0,
              children: List<Widget>.generate(
                Strings.tags.length,
                    (int index) {
                  return InputChip(
                    label: Text(Strings.tags[index]),
                    selected: selectedicon.contains(index),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selectedIndex == index) {
                          selectedicon.removeWhere((item) => item == selectedIndex);
                          selectedicontype.removeWhere((item) => item != Strings.tags[selectedicon[0]!]);
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                          selectedicon.add(selectedIndex);
                          selectedicontype.add(Strings.tags[selectedicon[selectedicon.length-1]!]);
                        }
                      });
                    },

                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      ),
    );
  }
}