import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_marketes/models/user_model.dart';
import 'package:pos_marketes/screens/login_in.dart';
import 'package:pos_marketes/screens/new_form.dart';

class FormScreen extends StatefulWidget {

  const FormScreen({Key? key, }) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // the logout function

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<ClientModel> loginUserData = [];




  late Stream slides;

  Future<Stream> _queryDb() async => slides = FirebaseFirestore.instance
      .collection('ClientsData')
      .doc(user!.uid)
      .collection("forms")
      .snapshots()
      .map((list) => list.docs.map((doc) => doc.data()));
  @override
  void initState() {
    super.initState();
    //getDataFrom();
    _queryDb();
    // getNeeds();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      _getColorFromHex("${loggedInUser.color}");
      setState(() {});
    });
    print("DAta of current =$slides");
  }

  Color? _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FirstLoginScreen()));
  }

  String greeting() {
    var hour = DateTime.now().hour;
    print("Hours are $hour");
    if (hour < 5) {
      return 'Night';
    }
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 14) {
      return 'Noon';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    if (hour < 20) {
      return 'Evening';
    }
    if (hour < 24) {
      return 'Night';
    }

    return 'Day';
  }

  late List slideList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      floatingActionButton: FloatingActionButton(
          shape: const StadiumBorder(),
          onPressed: () {
            //_launchWhatsapp();
            //whatsAppOpen(context);
            //launchWhatsapp();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewForm()));
          },
          elevation: 50,
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.add)),
      body: StreamBuilder(
    stream: slides,
    builder: (context, AsyncSnapshot snap) {
      if (snap.hasError) {
        return Center(child: const Text('Something went wrong'));
      }
      if (snap.connectionState ==
          ConnectionState.waiting) {
        return Center(child: const CircularProgressIndicator());
      }
      slideList = snap.data.toList();
      return Column(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.29,
              decoration: BoxDecoration(
                  color: _getColorFromHex("${loggedInUser.color}"),
                  borderRadius: BorderRadius.circular(20.0)),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Good ${greeting()}, ',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          Text(
                            '${loggedInUser.firstName}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          Text(
                            ' ${loggedInUser.secondName}',
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0,right: 20),
                        child: RaisedButton(
                          splashColor: Colors.yellow,
                          color: Colors.red,
                          padding: EdgeInsets.all(12.0),
                          shape: StadiumBorder(),
                          onPressed: () {
                            logout(context);
                          },
                          child: const Text(
                            'LOGOUT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children:  <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 2.0, left: 20),
                          child: Text(
                            'Total Meetings:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0, left: 3.0),
                          child: Text(
                            '${slideList.length}',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),


          SizedBox(
              height: MediaQuery.of(context).size.height * 0.71,
              child:slideList.isEmpty ? const Center(child: Text(
                  "No Meeting form yet\nKindly add by clicking the add button below"),)
                  :
              ListView.builder(
                        itemCount: slideList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Container(
                                  color: Colors.grey.withOpacity(0.3),
                                  child: Column(
                                    children: [
                                      AppBar(
                                        leading:
                                        const Icon(Icons.verified_user),
                                        elevation: 0,
                                        title:  Text('${slideList[index]["companyName"]}'),
                                        backgroundColor: Colors.green,
                                        centerTitle: true,
                                        actions: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Text("${index + 1}"),
                                          )
                                          // IconButton(
                                          //   icon: const Icon(Icons.delete),
                                          //   onPressed: (){},
                                          // )
                                        ],
                                      ),

                                      Column(
                                        children: [
                                          Text(
                                              "Date: ${slideList[index]["uploadTime"]}"),
                                          Row(
                                            children:  [
                                              Text(
                                                  "Client Role: ${slideList[index]["clientRole"]}"),
                                            ],
                                          ),
                                          Row(
                                            children:  [
                                              Text(
                                                  "Phone Number: ${slideList[index]["phoneNumber"]}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        })

          )
        ],
      );
    })


    );
  }
}

class WaveClipperTwo extends CustomClipper<Path> {
  /// reverse the wave direction in vertical axis
  bool reverse;

  /// flip the wave direction horizontal axis
  bool flip;

  WaveClipperTwo({this.reverse = false, this.flip = true});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse && !flip) {
      path.lineTo(0.0, size.height - 20);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
          Offset(size.width - (size.width / 3.25), size.height - 65);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (!reverse && flip) {
      path.lineTo(0.0, size.height - 40);
      var firstControlPoint = Offset(size.width / 3.25, size.height - 65);
      var firstEndPoint = Offset(size.width / 1.75, size.height - 20);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, size.height);
      var secondEP = Offset(size.width, size.height - 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height - 20);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (reverse && flip) {
      path.lineTo(0.0, 20);
      var firstControlPoint = Offset(size.width / 3.25, 65);
      var firstEndPoint = Offset(size.width / 1.75, 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, 0);
      var secondEP = Offset(size.width, 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
