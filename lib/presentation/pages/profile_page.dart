import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/login_model.dart';
import 'package:admin_simpass/data/models/profile_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_menu_drop_down.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController(text: '04/08/2024, 11:42:23 AM');
  final TextEditingController _expiryDateController = TextEditingController(text: '04/08/2024, 11:42:23 AM');

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passReentryController = TextEditingController();

  bool _isDataUpdating = false;

  String? _countryErrorText;

  List<dynamic> _roles = [];

  List<DropdownMenuEntry> _countries = [];

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    _countries = countryNameCodelist.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();
    _fetchProfileData();

    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();

    _countryController.dispose();
    _statusController.dispose();

    _startDateController.dispose();
    _expiryDateController.dispose();

    _oldPassController.dispose();
    _passReentryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(title: "나의 정보"),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  // color: Colors.amber.shade100,
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextInput(
                                controller: _userNameController,
                                title: '아이디',
                                readOnly: true,
                              ),
                            ),
                            const Gap(20),
                            Expanded(
                              child: CustomTextInput(
                                controller: _fullNameController,
                                title: '이름',
                                validator: InputValidator().validateName,
                              ),
                            ),
                          ],
                        ),
                        const Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextInput(
                                controller: _emailController,
                                title: '이메일',
                                validator: InputValidator().validateEmail,
                              ),
                            ),
                            const Gap(20),
                            Expanded(
                              child: CustomTextInput(
                                controller: _phoneNumberController,
                                title: '휴대전화',
                              ),
                            ),
                          ],
                        ),
                        const Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  // You can use constraints.maxWidth as the parent's width here.
                                  return CustomDropDownMenu(
                                    controller: _countryController,
                                    label: const Text("국가"),
                                    errorText: _countryErrorText,
                                    onSelected: (selectedItem) {
                                      _countryErrorText = null;
                                      setState(() {});
                                      print(selectedItem);
                                    },
                                    width: constraints.maxWidth,
                                    items: _countries,
                                    selectedItem: _countryController.text,
                                  );
                                },
                              ),
                            ),
                            const Gap(20),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  // You can use constraints.maxWidth as the parent's width here.
                                  return CustomDropDownMenu(
                                    controller: _statusController,
                                    enabled: false,
                                    label: const Text("상태"),
                                    // enabled: false,
                                    onSelected: (selectedItem) {
                                      print(selectedItem);
                                    },
                                    width: constraints.maxWidth,
                                    items: _countries,
                                    selectedItem: 34,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        const Text('권한'),
                        const Gap(5),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: _roles
                              .map(
                                (item) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black45,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: Text(
                                      item["description"] ?? "",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const Gap(30),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextInput(
                                // enabled: false,
                                readOnly: true,
                                controller: _startDateController,
                                title: '시작일자',
                              ),
                            ),
                            const Gap(20),
                            Expanded(
                              child: CustomTextInput(
                                // enabled: false,
                                readOnly: true,
                                controller: _expiryDateController,
                                title: '종료일자',
                              ),
                            ),
                          ],
                        ),
                        const Gap(30),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 50,
                            constraints: const BoxConstraints(minWidth: 150),
                            child: ElevatedButton(
                              onPressed: _isDataUpdating ? null : _updateProfileData,
                              child: _isDataUpdating ? const ButtonCircularProgressIndicator() : const Text('정보 저장'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade100,
                height: 80,
                thickness: 5,
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _fetchProfileData() async {
    print('fetch called');
    final APIService apiService = APIService();

    try {
      ProfileResponseModel result = await apiService.profileInfo(context);

      _roles = result.roles ?? [];
      _userNameController.text = result.username ?? "";
      _fullNameController.text = result.name ?? "";
      _emailController.text = result.email ?? "";
      _phoneNumberController.text = result.phoneNumber ?? "";
      _countryController.text = result.countryValue?["code"] ?? "";
      _statusController.text = result.statusNm ?? "";
      _startDateController.text = CustomFormat().formatDate(result.fromDate ?? "") ?? "";
      _expiryDateController.text = CustomFormat().formatDate(result.expireDate ?? "") ?? "";
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }

    setState(() {});
  }

  Future<void> _updateProfileData() async {
    if (_countryController.text.isEmpty) {
      _countryErrorText = "국가를 선택하세요.";
      setState(() {});
    }

    if (_formKey.currentState!.validate() && _countryController.text.isNotEmpty) {
      setState(() {
        _isDataUpdating = true;
      });
      print('update profile data here');
    }
  }
}
