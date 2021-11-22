import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_marketes/screens/form_screen.dart';
import 'package:pos_marketes/screens/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
          Fluttertoast.showToast(msg: "Login Successful"),
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => FormScreen())),
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
}




// import 'package:flutter/material.dart';
// import 'package:pos_marketes/screens/sign_up.dart';
//
// import 'form_screen.dart';
//
class FirstLoginScreen extends StatefulWidget {
  const FirstLoginScreen({Key? key}) : super(key: key);

  @override
  State<FirstLoginScreen> createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends State<FirstLoginScreen> {

  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;
  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
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
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child:
      RaisedButton(
        splashColor: Colors.yellow,
        color: Colors.red,
        padding: EdgeInsets.all(12.0),
        shape: StadiumBorder(),
        onPressed: () {
          signIn(emailController.text, passwordController.text);

        },
        child: const Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
      ),
     /* MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),*/
    );
    return GestureDetector(
      onTap: (){

        FocusScope.of(context).requestFocus(new FocusNode());

      },

      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 200.0,
              child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 540.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ),

            Positioned(
              top: 80.0,
              left: MediaQuery.of(context).size.width - 170.0,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 130.0,
                    height: 130.0,

                    decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                            image: AssetImage('assets/innvisol.png'))),
                  ),
                  Row(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Jelly',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, left: 5.0),
                        child: Text(
                          'ERP',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Positioned(
              top: 290.0,
              left: 40.0,
              child: SingleChildScrollView(
                child: Container(
                  //height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Welcome to',
                            style: TextStyle(color: Colors.black, fontSize: 20.0),
                          ),
                          Row(
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'POS',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0, left: 5.0),
                                child: Text(
                                  'Marketers',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Please sign in to continue',
                              style: TextStyle(color: Colors.black, fontSize: 15.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: SizedBox(
                              width: 250.0,
                              child: emailField,
                              /*TextField(
                                decoration: InputDecoration(
                                    labelText: 'Username',
                                    hintText: 'Enter your username',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    prefixIcon: const Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0))),
                              ),*/
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              width: 250.0,
                              child:  passwordField
                              /*TextField(
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    prefixIcon: const Icon(
                                      Icons.security,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0))),
                              )*/,
                            ),
                          ),

                          SizedBox(height: 45,),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 100.0,
                              height: 40.0,
                              child: loginButton,
                            ),
                          ),

                          const SizedBox(height: 20,),
                          Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegistrationScreen()));
                                  },
                                  child: const Text(
                                    "SignUp",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ])
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
             // bottom: 20,
              top: MediaQuery.of(context).size.height / 2 + 280.0,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Don\'t have an account?\nContact +923045708166',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  Row(
                    children: const <Widget>[

                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'INNVISOL',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, left: 3.0),
                        child: Text(
                          'TECHNOLOGIES',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            /*Positioned(
              top: MediaQuery.of(context).size.height / 2 + 140.0,
              left: MediaQuery.of(context).size.width - 200.0,
             // bottom: MediaQuery.of(context).size.width - 200.0 ,
              child: Container(
                width: 100.0,
                height: 40.0,
                child: RaisedButton(
                  splashColor: Colors.yellow,
                  color: Colors.red,
                  padding: EdgeInsets.all(12.0),
                  shape: StadiumBorder(),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const SignupScreen())
                    );
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
          Fluttertoast.showToast(msg: "Login Successful"),

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => FormScreen())),
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
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 80.0);

    var firstControlPoint = new Offset(50.0, size.height);
    var firstEndPoint = new Offset(size.width / 3.5, size.height - 45.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width - 30.0, size.height / 2);

    var secondControlPoint =
    new Offset(size.width + 15.0, size.height / 2 - 60.0);
    var secondEndPoint = new Offset(140.0, 50.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint = new Offset(50.0, 0.0);
    var thirdEndPoint = new Offset(0.0, 100.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
 }