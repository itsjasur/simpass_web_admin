import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/profile_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
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

  final TextEditingController _startDateController = TextEditingController(text: '04/08/2024, 11:42:23 AM');
  final TextEditingController _expiryDateController = TextEditingController(text: '04/08/2024, 11:42:23 AM');

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passReentryController = TextEditingController();

  List<dynamic> _roles = [];
  int? _userId;

  final _formKey = GlobalKey<FormState>();

  bool _isPageLoading = true;
  bool _isDataUpdating = false;

  String _selectedCountryCode = "";
  String? _countryErrorText;
  String _selectedStatusCode = "W";
  final List<DropdownMenuEntry> _countries = countryNameCodelist.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();
  final List<DropdownMenuEntry> _statuses = memberStatuses.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _startDateController.dispose();
    _expiryDateController.dispose();
    _oldPassController.dispose();
    _passReentryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isPageLoading
        ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              const Header(title: "나의 정보"),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '나의 정보',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(30),
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
                                        inputFormatters: [PhoneNumberFormatter()],
                                        maxlength: 13,
                                        title: '휴대전화',
                                        validator: InputValidator().validatePhoneNumber,
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
                                          //  use constraints.maxWidth as the parent's width here.
                                          return CustomDropDownMenu(
                                            label: const Text("국가"),
                                            errorText: _countryErrorText,
                                            enableSearch: true,
                                            onSelected: (selectedItem) {
                                              _selectedCountryCode = selectedItem;
                                              _countryErrorText = null;
                                              setState(() {});
                                            },
                                            width: constraints.maxWidth,
                                            items: _countries,
                                            selectedItem: _selectedCountryCode,
                                          );
                                        },
                                      ),
                                    ),
                                    const Gap(20),
                                    Expanded(
                                      child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          return CustomDropDownMenu(
                                            enabled: true,
                                            enableSearch: true,
                                            label: const Text("상태"),
                                            // onSelected: (selectedItem) {},
                                            width: constraints.maxWidth,
                                            items: _statuses,
                                            selectedItem: _selectedStatusCode,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(30),
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
                                        // readOnly: true,
                                        readOnly: true,
                                        controller: _startDateController,
                                        title: '시작일자',
                                      ),
                                    ),
                                    const Gap(20),
                                    Expanded(
                                      child: CustomTextInput(
                                        // readOnly: true,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 900,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '비밀번호 변경',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(30),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextInput(
                                      controller: _oldPassController,
                                      title: '현재 비밀번호',
                                      validator: InputValidator().validatePass,
                                      hidden: true,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                              const Gap(30),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextInput(
                                      controller: _passController,
                                      title: '새 비밀번호',
                                      validator: InputValidator().validatePass,
                                      hidden: true,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                              const Gap(30),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextInput(
                                      controller: _passReentryController,
                                      title: '새 비밀번호 확인',
                                      validator: (p) {
                                        return InputValidator().validateRentryPass(_passController.text, p);
                                      },
                                      hidden: true,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                              const Gap(30),
                              Container(
                                height: 50,
                                constraints: const BoxConstraints(minWidth: 150),
                                child: ElevatedButton(
                                  onPressed: _isDataUpdating ? null : _updateProfileData,
                                  child: _isDataUpdating ? const ButtonCircularProgressIndicator() : const Text('비밀번호 업데이트'),
                                ),
                              ),
                              const Gap(30),
                              const Text(
                                '강력한 비밀번호를 얻으려면 이 가이드를 따르세요.',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              const Gap(15),
                              const Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.black45, size: 13),
                                  SizedBox(width: 10),
                                  Text('특수 문자 1개'),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.black45, size: 13),
                                  SizedBox(width: 10),
                                  Text('최소 8 글자'),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.black45, size: 13),
                                  SizedBox(width: 10),
                                  Text('숫자 1개(2개 권장'),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.black45, size: 13),
                                  SizedBox(width: 10),
                                  Text('자주 바꾸세요'),
                                ],
                              ),
                              const Gap(100),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Future<void> _fetchProfileData() async {
    try {
      final APIService apiService = APIService();
      ProfileResponseModel result = await apiService.profileInfo(context);

      _roles = result.roles ?? [];
      _userNameController.text = result.username ?? "";
      _fullNameController.text = result.name ?? "";
      _emailController.text = result.email ?? "";
      _phoneNumberController.text = result.phoneNumber ?? "";
      _selectedCountryCode = result.countryValue?["code"] ?? "";
      _selectedStatusCode = result.status ?? "";
      _startDateController.text = CustomFormat().formatDateWithTime(result.fromDate ?? "") ?? "";
      _expiryDateController.text = CustomFormat().formatDateWithTime(result.expireDate ?? "") ?? "";
      _userId = result.id;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    setState(() {
      _isPageLoading = false;
    });
  }

  Future<void> _updateProfileData() async {
    _isDataUpdating = true;
    setState(() {});

    if (_selectedCountryCode.isEmpty) {
      _countryErrorText = "국가를 선택하세요.";
      setState(() {});
    }

    if (_formKey.currentState!.validate() && _selectedCountryCode.isNotEmpty && _userId != null) {
      try {
        final APIService apiService = APIService();

        await apiService.profileInfoUpdate(
          context,
          ProfileUpdateRequestModel(
            id: _userId!,
            username: _userNameController.text,
            name: _fullNameController.text,
            country: _selectedCountryCode,
            phoneNumber: _phoneNumberController.text,
            email: _emailController.text,
          ),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
    setState(() {
      _isDataUpdating = false;
    });
  }
}
