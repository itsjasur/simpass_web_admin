import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/custom_menu_drop_down.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ManageUsersPopupContent extends StatefulWidget {
  const ManageUsersPopupContent({super.key});

  @override
  State<ManageUsersPopupContent> createState() => _ManageUsersPopupContentState();
}

class _ManageUsersPopupContentState extends State<ManageUsersPopupContent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _statusController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController(text: '04/08/2024, 11:42:23 AM');
  final TextEditingController _expiryDateController = TextEditingController(text: '04/08/2024, 11:42:23 AM');

  String? _countryErrorText;

  final String _selectedCountryCode = countryNameCodelist[0]['code'];
  final List<DropdownMenuEntry> _countries = countryNameCodelist.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();

  final List<Map<String, dynamic>> _userRolesList = userRolesList;

  Set _globalLowRoleCodes = {"ROLE_ADMIN"};
  Set _globalHighRoleCodes = {"ROLE_ADMIN"};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();

    _statusController.dispose();

    _startDateController.dispose();
    _expiryDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        width: 800,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(50),
            const Text(
              "사용자 수정",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(20),
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
                        onSelected: (selectedItem) {
                          setState(() {
                            _countryErrorText = null;
                          });
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
                        controller: _statusController,
                        enabled: false,
                        label: const Text("상태"),
                        // onSelected: (selectedItem) {},
                        width: constraints.maxWidth,
                        items: _countries,
                        // selectedItem: ,
                      );
                    },
                  ),
                ),
              ],
            ),
            const Gap(30),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_userRolesList.length, (index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: _userRolesList[index]['state'] == "hidden"
                      ? null
                      : () {
                          _updateUserRoles(index);
                        },
                  onHover: (value) {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                          visualDensity: VisualDensity.compact,
                          value: _userRolesList[index]['checked'],
                          onChanged: _userRolesList[index]['state'] == "hidden"
                              ? null
                              : (newValue) {
                                  _updateUserRoles(index);
                                },
                        ),
                        const Gap(5),
                        Flexible(
                            child: Text(
                          _userRolesList[index]['label'],
                          style: TextStyle(color: _userRolesList[index]['state'] == 'hidden' ? Colors.black45 : Colors.black),
                        )),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserRoles(index) {
    //checking highrole list and showing popup
    //updating checkbox only if the index role high low not available in global highlow list
    if (!_userRolesList[index]["checked"]) {
      if (_globalHighRoleCodes.contains(_userRolesList[index]["code"])) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 선택권한의 하위권한이 선택 또는 존재합니다.")),
          );
        }
        return;
      } else {
        _userRolesList[index]['checked'] = true;
      }
    } else {
      _userRolesList[index]['checked'] = false;
    }

    //extracting low and high roles
    for (var role in _userRolesList) {
      if (role['code'] == _userRolesList[index]['code']) {
        if (_userRolesList[index]["checked"]) {
          _globalLowRoleCodes.addAll(role["low"]);
          _globalHighRoleCodes.addAll(role["high"]);
        } else {
          _globalLowRoleCodes.removeWhere((item) => role["low"].contains(item));
          _globalHighRoleCodes.removeWhere((item) => role["high"].contains(item));
        }
      }
    }

    //updating checkbox
    for (int i = 0; i < _userRolesList.length; i++) {
      _userRolesList[i]['state'] = "active";
      if (_globalLowRoleCodes.contains(_userRolesList[i]["code"])) {
        _userRolesList[i]['state'] = "hidden";
      }
    }

    setState(() {});
  }
}
