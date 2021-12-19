import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stargram/pages/main_page.dart';
import 'package:stargram/user.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Center(
            child: Text(
              "Stargram",
              style: TextStyle(
                fontFamily: "SillyHandScript",
                fontSize: 60,
              ),
            ),
          ),
          SizedBox(height: 100),
          Center(
              child: Padding(
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "ID"),
              keyboardType: TextInputType.text,
            ),
            padding: EdgeInsets.all(50.0),
          )),
          SizedBox(height: 20),
          Center(
            child: Padding(
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "EMAIL"),
                keyboardType: TextInputType.emailAddress,
              ),
              padding: EdgeInsets.all(50.0),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
              width: 300,
              height: 50,
              child: OutlinedButton(
                onPressed: () => _register(context),
                child: Text("Register"),
              )),
          SizedBox(height: 50),
          TextButton(
            child: Text("계정이 이미 있으신가요? 로그인하기"),
            onPressed: () => {Navigator.pushNamed(context, "/login")},
          )
        ],
      ),
    );
  }

  void _register(BuildContext ctx) async {
    var name = _nameController.text;
    var email = _emailController.text;
    var url = Uri.parse("http://10.0.2.2:8080/user");
    var response = await http
        .post(url, body: jsonEncode({"name": name, "email": email}), headers: {
      "Accept": "*/*",
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/json"
    });
    if (response.statusCode != 200) {
      showDialog(
          context: ctx, builder: (context) => RegisterFailDialogWidget());
    } else {
      Map<String, dynamic> result = json.decode(response.body);
      final user = User(result["name"], result["id"], result["email"]);
      Navigator.pushNamed(ctx, "/home", arguments: MainPageArgument(user));
    }
  }
}

class RegisterFailDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("가입에 실패하였습니다."),
      content: Text("다시 시도해주세요"),
      actions: [
        TextButton(
            onPressed: () => {Navigator.pop(context, "register")},
            child: Text("OK"))
      ],
    );
  }
}
