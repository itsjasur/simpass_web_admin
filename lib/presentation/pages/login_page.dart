import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/custom_text_button.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/logo.png",
                    color: MainUi.mainColor,
                    height: 50,

                    // fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),

                      const Text(
                        '로그인',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '사용자 아이디 와 비밀번호를 입력하세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 50),

                      //ID text field
                      CustomTextInput(
                        controller: _idController,
                        title: '사용자 아이디',
                        validator: _validateId,
                      ),
                      const SizedBox(height: 10),
                      //password fiel
                      CustomTextInput(
                        controller: _passController,
                        title: '비밀번호',
                        validator: _validatePass,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Colors.amber,
                            ),
                            foregroundColor: MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          child: const Text('로그인'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('계정이 없나요?'),
                          const SizedBox(width: 10),
                          CustomTextButton(
                            title: '사용자 등록',
                            onTap: () {},
                          ),
                        ],
                      ),

                      // password text field
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  text: const TextSpan(
                    // style: TextStyle(
                    //   color: Colors.black, // You can set the default color
                    // ),
                    children: <TextSpan>[
                      TextSpan(text: 'Copyright © '),
                      TextSpan(
                        text: 'Simpass Inc.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' All rights reserved.'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateId(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) {
      return '사용자 ID를 입력하세요.';
    }

    // if (value.length < 2) {
    //   return 'ID length should be longer than 6';
    // }

    return null; //if the input is value
  }

  String? _validatePass(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요.';
    }

    // if (value.length < 2) {
    //   return 'ID length should be longer than 6';
    // }

    return null; //if the input is value
  }
}
