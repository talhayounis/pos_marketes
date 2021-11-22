import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pos_marketes/models/user_model.dart';
import 'package:pos_marketes/screens/form_screen.dart';


class NewForm extends StatefulWidget {
  const NewForm({Key? key}) : super(key: key);

  @override
  _NewFormState createState() => _NewFormState();
}

class _NewFormState extends State<NewForm> {
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message

  late String location;
  late String Address;
  String? errorMessage;


  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final phoneNumberController = new TextEditingController();


  final emailController = new TextEditingController();


  getLocat() async{
    Position position = await _getGeoLocationPosition();
    location =
    'Lat: ${position.latitude} , Long: ${position
        .longitude}';
    GetAddressFromLatLong(position);
  }

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    // TODO: implement initState
    getLocat();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    super.initState();
  }

   String? selectedCategory;
   String? selectedRole;
  @override
  Widget build(BuildContext context) {
    //first name field
    final fullName = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Client Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Client Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final phoneNumber = TextFormField(
        autofocus: false,
        controller: phoneNumberController,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Phone No cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          phoneNumberController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //second name field
    final companyName = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Company Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Business Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final clientRole = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Client Role cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Write Role",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final contactPersonEmail = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Client email cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final clientMsg = TextFormField(
        autofocus: false,
        controller: passwordEditingController,

        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Message is required");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        maxLines: 3,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),

          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Message",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,

        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Address";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: const Text(
            "Save",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return GestureDetector(
      onTap: (){

        FocusScope.of(context).requestFocus(new FocusNode());

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
           // color: Colors.white
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                   // SizedBox(height: 45),
                    const Text("Business", style: TextStyle(fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                          child: Column( //mjy mil gai access
                            //ty fair minu v dey okay system prefrences sy milti ha dobara sy abb join kry ga toh ?'

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              companyName,
                              const SizedBox(height: 15),
                             // phoneNumber,

                              // DropdownButton<String>(
                              //   items: <String>['A', 'B', 'C', 'D'].map((String value) {
                              //     return DropdownMenuItem<String>(
                              //       value: value,
                              //       child: Text(value),
                              //     );
                              //   }).toList(),
                              //   onChanged: (_) {},
                              // ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 60,
                                      child: InputDecorator(
                                        decoration:  InputDecoration(
                                          border:  OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.teal),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                         // labelText: "Category",
                                          hintText:"Select Category",
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            hint: Text("Bussniess Type"),
                                            value: selectedCategory,
                                            items: <String>['Pharmacy', 'Mart', 'Bakeries', 'Education','Other'].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (dynamic newValue) {
                                              setState(() {
                                                selectedCategory=newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              selectedCategory == 'Other'? SizedBox(height: 15,) : SizedBox(),
                              selectedCategory == 'Other'? companyName : SizedBox()
                            ],
                          )),
                    ),
                    SizedBox(height: 15),
                    const Text("Contact Person",style: TextStyle(fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              fullName,
                              SizedBox(height: 15),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: selectedRole != 'Other'? 60 : null,
                                      child: InputDecorator(
                                        decoration:  InputDecoration(
                                          border:  OutlineInputBorder(
                                            borderSide: new BorderSide(color: Colors.teal),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          // labelText: "Category",
                                          hintText:"Select Category",
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                        child: Wrap(

                                          children: [
                                            DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                hint: const Text("Contact Person Role"),
                                                value: selectedRole,
                                                items: <String>['CEO', 'Decision Maker','Owner', 'Employee', 'Manager','Other'].map((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                                onChanged: (dynamic newValue) {
                                                  setState(() {
                                                    selectedRole=newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                            selectedRole == 'Other'? clientRole : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              selectedRole == 'Other'? SizedBox(height: 15,) : SizedBox(),
                              selectedRole == 'Other'? clientRole : SizedBox(),
                              // SizedBox(height: 15),
                              // clientRole,

                              SizedBox(height: 15),
                              phoneNumber,
                              SizedBox(height: 15),
                              contactPersonEmail,
                            ],
                          )),
                    ),
                    phoneNumber,
                    SizedBox(height: 20),
                    fullName,
                    SizedBox(height: 20),
                    clientRole,
                    SizedBox(height: 20),
                    clientMsg,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    signUpButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {

        await postDetailsToFirestore()
            //.then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
    '${place.street}, ${place.subLocality}, ${place.locality}, ${place
        .postalCode}, ${place.country}';
    setState(() {

    });
  }
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    ClientModel userModel = ClientModel();

    // writing all the values

    userModel.uid = user!.uid;
    userModel.clientName = firstNameEditingController.text;
    userModel.phoneNumber = phoneNumberController.text.toString();
    userModel.companyName = secondNameEditingController.text;
    userModel.clientRole = emailEditingController.text;
    userModel.message = passwordEditingController.text;
    userModel.address = confirmPasswordEditingController.text;
    userModel.currentLocation = Address;
    userModel.uploadTime =  DateTime.now().toString();
    userModel.formFilledBy = "${loggedInUser.firstName}  ${loggedInUser.secondName}";

    await firebaseFirestore
        .collection("ClientsData")
        .doc(user.uid).collection("forms")
        .add(userModel.toMap());
    Fluttertoast.showToast(msg: "Data added successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => FormScreen()),
            (route) => false);
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