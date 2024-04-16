import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/member_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_menu_drop_down.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/date_time_picker.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ManageUsersPopupContent extends StatefulWidget {
  final String userName;
  final int userId;
  final bool isNew;
  const ManageUsersPopupContent({super.key, required this.userName, required this.userId, this.isNew = false});

  @override
  State<ManageUsersPopupContent> createState() => _ManageUsersPopupContentState();
}

class _ManageUsersPopupContentState extends State<ManageUsersPopupContent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _countryErrorText;

  final TextEditingController _fromDateController = TextEditingController(text: DateTime.now().toString());
  final TextEditingController _expiryDateController = TextEditingController(text: DateTime.now().add(const Duration(days: 365)).toString());

  String _selectedCountryCode = countryNameCodelist[0]['code'];
  String _selectedStatusCode = memberStatuses[0]['code'];

  final List<DropdownMenuEntry> _countries = countryNameCodelist.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();
  final List<DropdownMenuEntry> _statuses = memberStatuses.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();

  final List<Map<String, dynamic>> _userRolesList = userRolesList;
  final _formKey = GlobalKey<FormState>();

  final Set _globalLowRoleCodes = {};
  final Set _globalHighRoleCodes = {};

  bool _dataLoading = true;
  bool _dataUpdating = false;

  @override
  void initState() {
    if (!widget.isNew) _fetchData();

    super.initState();
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _expiryDateController.dispose();
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _dataLoading
        ? const SizedBox(
            height: 300,
            child: Align(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  const Text(
                    "사용자 수정",
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
                          validator: InputValidator().validateId,
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
                                if (selectedItem != null) _selectedCountryCode = selectedItem;
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
                            //  use constraints.maxWidth as the parent's width here.
                            return CustomDropDownMenu(
                              label: const Text("상태"),
                              onSelected: (selectedItem) {
                                if (selectedItem != null) _selectedStatusCode = selectedItem;
                              },
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
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      _userRolesList.length,
                      (index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: _userRolesList[index]['state'] == "hidden"
                              ? null
                              : () {
                                  _changeUserRoles(index);
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
                                          _changeUserRoles(index);
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
                      },
                    ),
                  ),
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            CustomTextInput(
                              controller: _fromDateController,
                              title: '시작일자',
                              onTap: () async {
                                String? selectedDate = await showDateTimePicker(context);
                                if (selectedDate != null) _fromDateController.text = CustomFormat().formatDate(selectedDate) ?? "";
                              },
                              readOnly: true,
                            ),
                            const Positioned(
                              right: 10,
                              child: IgnorePointer(
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            CustomTextInput(
                              controller: _expiryDateController,
                              onTap: () async {
                                String? selectedDate = await showDateTimePicker(context);
                                if (selectedDate != null) _expiryDateController.text = CustomFormat().formatDate(selectedDate) ?? "";
                              },
                              readOnly: true,
                              title: '종료일자',
                            ),
                            const Positioned(
                              right: 10,
                              child: IgnorePointer(
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(40),
                  Align(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      runSpacing: 20,
                      spacing: 20,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("취소"),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            onPressed: _dataUpdating
                                ? null
                                : () {
                                    _updateMemberData();
                                  },
                            child: _dataUpdating ? const ButtonCircularProgressIndicator() : const Text("저장"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> _fetchData() async {
    // await Future.delayed(Duration(seconds: 2));

    // //not showing super admin and admin from the chosen list depending on self role
    // List<String> myRolesList = await Provider.of<MyinfoProvifer>(context, listen: false).getRolesList();

    // _globalHighRoleCodes.addAll(myRolesList);
    // _globalLowRoleCodes.addAll(myRolesList);

    //updating checkbox

    final APIService apiService = APIService();
    if (mounted) {
      MemberModel memberInfo = await apiService.fetchMemberInfo(context: context, memberUserName: widget.userName);

      _userNameController.text = memberInfo.username;
      _fullNameController.text = memberInfo.name ?? '';
      _emailController.text = memberInfo.email ?? "";
      _phoneNumberController.text = memberInfo.phoneNumber ?? "";
      _selectedCountryCode = memberInfo.country ?? "";
      _fromDateController.text = CustomFormat().formatDate(memberInfo.fromDate) ?? "";
      _expiryDateController.text = CustomFormat().formatDate(memberInfo.expireDate) ?? "";

      List<dynamic> rolesList = memberInfo.strRoles ?? [];
      // print(rolesList);
      _globalHighRoleCodes.addAll(rolesList);
      // _globalLowRoleCodes.addAll(rolesList);

      for (String role in rolesList) {
        for (int i = 0; i < _userRolesList.length; i++) {
          if (role == _userRolesList[i]['code']) {
            _userRolesList[i]['checked'] = true;
          }
        }
      }
    }
    _dataLoading = false;
    setState(() {});
  }

  void _changeUserRoles(index) {
    //checking highrole list and showing popup
    //updating checkbox only if the index role high low not available in global highlow list

    if (!_userRolesList[index]["checked"]) {
      if (_globalHighRoleCodes.contains(_userRolesList[index]["code"])) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("이미 선택권한의 하위권한이 선택 또는 존재합니다."),
            ),
          );
        }
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

    //updating state
    for (int i = 0; i < _userRolesList.length; i++) {
      _userRolesList[i]['state'] = "active";
      if (_globalLowRoleCodes.contains(_userRolesList[i]["code"])) {
        _userRolesList[i]['state'] = "hidden";
      }
    }

    setState(() {});
  }

  Future<void> _updateMemberData() async {
    if (_selectedCountryCode.isEmpty) {
      _countryErrorText = "국가를 선택하세요.";
      setState(() {});
    }

    _dataUpdating = true;
    setState(() {});

    if (_formKey.currentState!.validate() && _selectedCountryCode.isNotEmpty) {
      final APIService apiService = APIService();

      await apiService.memberInfoUpdate(
        context,
        MemberModel(
          id: widget.userId,
          username: widget.userName,
          email: _emailController.text,
          name: _fullNameController.text,
          status: _selectedStatusCode,
          fromDate: CustomFormat().formatDateReverse(_fromDateController.text).toString(),
          expireDate: CustomFormat().formatDateReverse(_expiryDateController.text).toString(),
          country: _selectedCountryCode,
          phoneNumber: _phoneNumberController.text,
          strRoles: _userRolesList.where((role) => role['checked'] == true).map((role) => role['label'].toString()).toList(),
        ),
      );
    }

    _dataUpdating = false;
    setState(() {});
  }
}
