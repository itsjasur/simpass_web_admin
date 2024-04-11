import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/signup_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:admin_simpass/presentation/components/custom_menu_drop_down.dart';
import 'package:admin_simpass/presentation/components/custom_text_button.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  final TextEditingController _countryController = TextEditingController();

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passReentryController = TextEditingController();

  String? _countryErrorText;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<DropdownMenuEntry> _countries = [];

  @override
  void initState() {
    _phoneNumberController.addListener(_formatPhoneNumber);

    _countries = countryNameCodelist.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();

    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _phoneNumberController.dispose();
    _passController.dispose();
    _passReentryController.dispose();

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
                const SizedBox(height: 50),
                const Align(
                  alignment: Alignment.center,
                  child: ClickableLogo(
                    height: 50,
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
                        validator: InputValidator().validateEmail,
                      ),
                      const SizedBox(height: 20),

                      //phone number text field
                      CustomTextInput(
                        controller: _phoneNumberController,
                        maxlength: 13,
                        title: '휴대전화',
                        validator: InputValidator().validatePhoneNumber,
                      ),
                      const SizedBox(height: 20),

                      //country text menu field

                      LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          // You can use constraints.maxWidth as the parent's width here.
                          return CustomDropDownMenu(
                            controller: _countryController,
                            label: const Text("국가"),
                            errorText: _countryErrorText,
                            onSelected: (selectedItem) {
                              _countryController.text = countryNameCodelist.firstWhere((e) => e['code'] == selectedItem)['label'];

                              _countryErrorText = null;
                              setState(() {});
                            },
                            width: constraints.maxWidth + 7,
                            items: _countries,
                            selectedItem: 34,
                          );
                        },
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
                          child: _isLoading ? const ButtonCircularProgressIndicator() : const Text('등록하기'),
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
    if (_countryController.text.isEmpty) {
      _countryErrorText = "국가를 선택하세요.";
      setState(() {});
    }

    if (_formKey.currentState!.validate() && _countryController.text.isNotEmpty) {
      try {
        final APIService apiService = APIService();

        await apiService.signup(
          context,
          SignupRequestModel(
            userName: _userNameController.text,
            password: _passController.text,
            email: _emailController.text,
            fullName: _fullNameController.text,
            country: _countryController.text,
            phoneNumber: _phoneNumberController.text,
          ),
        );

        _isLoading = false;
        setState(() {});

        if (mounted) context.go('/login');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  void _formatPhoneNumber() {
    String text = _phoneNumberController.text.replaceAll('-', '');
    if (text.length > 3 && text.length <= 7) {
      text = '${text.substring(0, 3)}-${text.substring(3)}';
    } else if (text.length > 7) {
      text = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7, text.length)}';
    }
    // Update the controller without causing infinite loop
    if (text != _phoneNumberController.text) {
      _phoneNumberController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }
}
