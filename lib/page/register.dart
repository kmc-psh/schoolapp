import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ResgisterScreen extends StatefulWidget {
  const ResgisterScreen({Key? key}) : super(key: key);

  @override
  State<ResgisterScreen> createState() => _ResgisterScreenState();
}

class _ResgisterScreenState extends State<ResgisterScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('register');
  var _idTextController = TextEditingController();
  var _pwTextController = TextEditingController();

  OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: Colors.white));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                controller: _idTextController,
                cursorColor: Colors.black,
                // controller: _idController,
                validator: (text) {
                  // if (text == null || text.isEmpty) {
                  //   return '입력창이 비었음';
                  // }
                  // return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: const Icon(
                      Icons.face_retouching_natural,
                      color: Colors.blue,
                    ),
                    border: _border,
                    focusedBorder: _border,
                    hintText: 'id',
                    hintStyle: const TextStyle(color: Colors.blue)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _pwTextController,
                cursorColor: Colors.black,
                // controller: _idController,
                validator: (text) {
                  // if (text == null || text.isEmpty) {
                  //   return '입력창이 비었음';
                  // }
                  // return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: const Icon(
                      Icons.face_retouching_natural,
                      color: Colors.blue,
                    ),
                    border: _border,
                    focusedBorder: _border,
                    hintText: 'password',
                    hintStyle: const TextStyle(color: Colors.blue)),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    users.add({
                      'id': _idTextController.text,
                      'password': _pwTextController.text
                    });
                    print(users.add({
                      'id': _idTextController.text,
                      'password': _pwTextController.text
                    }));
                  },
                  child: const Text('회원가입'))
            ],
          ),
        ),
      ),
    );
  }
}
