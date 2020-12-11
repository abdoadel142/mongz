import 'dart:convert';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mongz/Views/first_page.dart';
import 'package:mongz/NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  static const id = '/auth';
  var done = false;
  var status;
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

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
        usernameHint: 'Email',
        passwordHint: 'Password',
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

  signup(email, password) async {
    Map<String, String> data = {
      "email": email,
      "password": password,
    };
    var response = await networkHandler.put("/auth/signup", data);

    if (response.statusCode == 422) {
      throw Exception(
          "Validation failed. Make sure the email address isn't used yet!");
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Creating a user failed!');
    }
    Map<String, dynamic> output = json.decode(response.body);
    print("SignUp Store Token: ");
    print(output["token"]);
    await storage.write(key: "token", value: output["token"]);
    done = true;
  }

  login(email, password) async {
    Map<String, String> data = {
      "email": email,
      "password": password,
    };
    var response = await networkHandler.post("/auth/login", data);
    if (response.statusCode == 422) {
      throw Exception('Validation failed.');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not authenticate you!');
    }
    Map<String, dynamic> output = json.decode(response.body);
    print("Login Store Token : ");
    print(output["token"]);
    await storage.write(key: "token", value: output["token"]);
    done = true;
  }

  resetpassword(email) async {
    Map<String, String> data = {
      "email": email,
    };
    var response = await networkHandler.post("/auth/login", data);
    if (response.statusCode == 422) {
      throw Exception('Validation failed.');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not authenticate you!');
    }
    Map<String, dynamic> output = json.decode(response.body);
    status = response.statusCode;
    print(response.statusCode);
    done = true;
  }
}
