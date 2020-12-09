import 'dart:convert';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:mongz/Views/first_page.dart';
import 'package:mongz/Views/map_screen.dart';

class LoginScreen extends StatelessWidget {
  static const id = '/auth';
  var done = false;
  var status;
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  signup(email, password) async {
    var url = "http://192.168.1.3:8080/signup";

    final http.Response response = await http.put(
      url,
      // headers: {'Content-Type': 'application/json'},
      headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 422) {
      throw Exception('validation faild');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      print(response.statusCode);

      throw Exception('could not authentcate you');
    }
    if (response.statusCode == 200) {
//      Navigator.pushReplacementNamed(context, home_main.id);
      done = true;
    }
  }

  login(email, password) async {
    var url = "http://192.168.1.3:8080/login";

    final http.Response response = await http.post(
      url,
      // headers: {'Content-Type': 'application/json'},
      headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    status = response.statusCode;
    print(response.statusCode);
    if (response.statusCode == 422) {
      throw Exception('validation faild');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      print(response.statusCode);
      throw Exception('could not authentcate you');
    }
    if (response.statusCode == 200) {
      done = true;
    }
  }

  Future<String> _SignUPUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      await signup(data.name, data.password);
      if (done == true) {
        return null;
      } else {
        return 'invalid email or password';
      }
    });
  }

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      await login(data.name, data.password);
      if (done == true) {
        return null;
      } else {
        return 'invalid user or password';
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {});
  }

  resetpassword(email) async {
    var url = "http://192.168.1.3:8080/login";

    final http.Response response = await http.post(
      url,
      // headers: {'Content-Type': 'application/json'},
      headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    status = response.statusCode;
    print(response.statusCode);
    if (response.statusCode == 422) {
      done = false;
      throw Exception('validation faild');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      print(response.statusCode);
      throw Exception('could not authentcate you');
    }
    if (response.statusCode == 200) {
      done = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      title: 'Mongz',
      logo: 'images/logol.png',
      messages: LoginMessages(
        usernameHint: 'Username',
        passwordHint: 'Pass',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot huh?',
        recoverPasswordButton: 'HELP ME',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
        recoverPasswordDescription:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
      //  theme: LoginTheme(primaryColor: Colors.orange),
//      theme: LoginTheme(
//        primaryColor: Colors.teal,
//        accentColor: Colors.yellow,
//        errorColor: Colors.deepOrange,
//        pageColorLight: Colors.indigo.shade300,
//        pageColorDark: Colors.indigo.shade500,
//        titleStyle: TextStyle(
//          color: Colors.greenAccent,
//          fontFamily: 'Quicksand',
//          letterSpacing: 4,
//        ),
//        // beforeHeroFontSize: 50,
//        // afterHeroFontSize: 20,
//        bodyStyle: TextStyle(
//          fontStyle: FontStyle.italic,
//          decoration: TextDecoration.underline,
//        ),
//        textFieldStyle: TextStyle(
//          color: Colors.orange,
//          shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
//        ),
//        buttonStyle: TextStyle(
//          fontWeight: FontWeight.w800,
//          color: Colors.yellow,
//        ),
//        cardTheme: CardTheme(
//          color: Colors.yellow.shade100,
//          elevation: 5,
//          margin: EdgeInsets.only(top: 15),
//          shape: ContinuousRectangleBorder(
//              borderRadius: BorderRadius.circular(100.0)),
//        ),
//        inputTheme: InputDecorationTheme(
//          filled: true,
//          fillColor: Colors.purple.withOpacity(.1),
//          contentPadding: EdgeInsets.zero,
//          errorStyle: TextStyle(
//            backgroundColor: Colors.orange,
//            color: Colors.white,
//          ),
//          labelStyle: TextStyle(fontSize: 12),
//          enabledBorder: UnderlineInputBorder(
//            borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
//            borderRadius: inputBorder,
//          ),
//          focusedBorder: UnderlineInputBorder(
//            borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
//            borderRadius: inputBorder,
//          ),
//          errorBorder: UnderlineInputBorder(
//            borderSide: BorderSide(color: Colors.red.shade700, width: 7),
//            borderRadius: inputBorder,
//          ),
//          focusedErrorBorder: UnderlineInputBorder(
//            borderSide: BorderSide(color: Colors.red.shade400, width: 8),
//            borderRadius: inputBorder,
//          ),
//          disabledBorder: UnderlineInputBorder(
//            borderSide: BorderSide(color: Colors.grey, width: 5),
//            borderRadius: inputBorder,
//          ),
//        ),
//        buttonTheme: LoginButtonTheme(
//          splashColor: Colors.purple,
//          backgroundColor: Colors.pinkAccent,
//          highlightColor: Colors.lightGreen,
//          elevation: 9.0,
//          highlightElevation: 6.0,
//          shape: BeveledRectangleBorder(
//            borderRadius: BorderRadius.circular(10),
//          ),
//          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//          // shape: CircleBorder(side: BorderSide(color: Colors.green)),
//          // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
//        ),
//      ),
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _SignUPUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, firstPage.id);
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      //showDebugButtons: true,
    );
  }
}
