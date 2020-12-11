import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongz/Views/map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mongz/Views/profile_page.dart';

class firstPage extends StatefulWidget {
  static const id = 'first';
  @override
  _firstPageState createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  Position _currentPosition;
  String _currentAddress;
  Future<Position> current_position;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Widget profilePhoto = Container(
    height: 90,
    width: 90,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
    ),
    alignment: Alignment.topRight,
  );

  void checkProfile() async {
    // var response = await networkHandler.get("/profile/checkProfile");
    // setState(() {
    //   username = response['username'];
    // });
    // if (response["status"] == true) {
    //   setState(() {
    //     profilePhoto = CircleAvatar(
    //       radius: 50,
    //       backgroundImage: NetworkHandler().getImage(response['username']),
    //     );
    //   });
    // } else {
    setState(() {
      profilePhoto = Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.topRight,
      );
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          Icon(
            Icons.shopping_cart,
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.notifications_active,
          ),
          SizedBox(
            width: 10,
          ),
        ],
        title: Text(
          "Mongz",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Mongz",
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 6, fontSize: 20),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
            ),
            // DrawerHeader(
            //   child: Text(
            //     'Mongz',
            //     style: TextStyle(
            //         color: Colors.white, letterSpacing: 6, fontSize: 20),
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.orange,
            //   ),
            // ),
            ListTile(
              title: Text('Home'),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              title: Text('Your Orders'),
              trailing: Icon(Icons.fastfood),
              onTap: () {},
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              title: Text('Offers'),
              trailing: Icon(Icons.loyalty),
              onTap: () {},
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              title: Text('Notifications'),
              trailing: Icon(Icons.notifications),
              onTap: () {},
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              title: Text('About'),
              trailing: Icon(Icons.error_outline),
              onTap: () {},
            ),
          ],
        ),
      ),
      // backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      extendBody: true,

      body: Container(
//        color: Colors.orange,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.location_on,
                color: Colors.deepOrangeAccent,
                size: 50.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Explor Nearby Vendors',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => map_screen(
                      position: _currentPosition,
                    ),
                  ),
                );
              },
              color: Colors.orangeAccent,
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('show', style: TextStyle(color: Colors.white)),
              onPressed: _modalBottomSheetMenu,
              color: Colors.orangeAccent,
            ),
          ],
        )),
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text(
                  'Choose delivery location',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Your Location'),
                subtitle: _currentAddress == null
                    ? Text("egypt street")
                    : Text(_currentAddress),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.location_searching),
                title: Text('Delever to current location'),
                subtitle: Text("Enable device location"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.mapPin),
                title: Text('Delever to different location'),
                subtitle: Text("Choose location on the map"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, map_screen.id);
                },
              ),
            ],
          );
        });
  }
}
