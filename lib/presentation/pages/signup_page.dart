import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:admin_simpass/presentation/components/custom_text_button.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passReentryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 80),
                const SizedBox(
                  height: 50,
                  child: ClickableLogo(),
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
                        '관리자 등록요청',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '기본정보 입력하세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 50),

                      //ID text field
                      CustomTextInput(
                        controller: _userNameController,
                        title: '아이디',
                        validator: InputValidator().validateId,
                      ),
                      const SizedBox(height: 20),

                      //name text field
                      CustomTextInput(
                        controller: _fullNameController,
                        title: '이름',
                        validator: InputValidator().validateName,
                      ),
                      const SizedBox(height: 20),

                      //email text field
                      CustomTextInput(
                        controller: _emailController,
                        title: '이매일',
                        validator: InputValidator().validateName,
                      ),
                      const SizedBox(height: 20),

                      //phone number text field
                      CustomTextInput(
                        controller: _phoneNumberController,
                        title: '휴대전화',
                        validator: InputValidator().validateName,
                      ),
                      const SizedBox(height: 20),

                      //password fiel
                      CustomTextInput(
                        controller: _passController,
                        title: '비밀번호',
                        validator: InputValidator().validatePass,
                        hidden: true,
                      ),
                      const SizedBox(height: 25),

                      //password reentry fiel
                      CustomTextInput(
                        controller: _passReentryController,
                        title: '비밀번호 확인',
                        validator: (p0) => InputValidator().validateRentryPass(_passController.text, p0),
                        hidden: true,
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signup,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                )
                              : const Text('등록하기'),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('이미 계정을 가지고 계십니까?'),
                          const SizedBox(width: 10),
                          CustomTextButton(
                            title: '로그인',
                            onTap: () {
                              context.go('/login');
                            },
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

  Future<void> _signup() async {
    final APIService apiService = APIService();
    print("signup pressed");
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
  }
}
