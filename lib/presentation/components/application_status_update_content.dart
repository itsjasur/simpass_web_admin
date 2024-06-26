import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/code_value_model.dart';

class ApplicationStatusUpdateContent extends StatefulWidget {
  final List<CodeValue> items;
  final String applicationID;
  final Function? callBack;
  final String selectedStatusCode;

  const ApplicationStatusUpdateContent({super.key, required this.items, required this.applicationID, this.callBack, required this.selectedStatusCode});

  @override
  State<ApplicationStatusUpdateContent> createState() => _ApplicationStatusUpdateContentState();
}

class _ApplicationStatusUpdateContentState extends State<ApplicationStatusUpdateContent> {
  final TextEditingController _phoneNumberCnt = TextEditingController(text: '010-');

  String _selectedStatusCode = "";
  final _formKey = GlobalKey<FormState>();
  bool _updating = false;

  String? _statusErrorCode;

  @override
  void initState() {
    super.initState();
    _selectedStatusCode = widget.selectedStatusCode;
  }

  @override
  void dispose() {
    _phoneNumberCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '상태 수정',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(20),
                LayoutBuilder(
                  builder: (context, constraints) => CustomDropDownMenu(
                    label: const Text("상태"),
                    enableSearch: true,
                    items: widget.items.where((i) => i.cd.isNotEmpty).map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList(),
                    width: constraints.maxWidth,
                    errorText: _statusErrorCode,
                    selectedItem: _selectedStatusCode,
                    onSelected: (selectedItem) {
                      _selectedStatusCode = selectedItem;
                      _statusErrorCode = null;
                      setState(() {});
                    },
                  ),
                ),
                const Gap(20),
                if (_selectedStatusCode == 'Y')
                  CustomTextInput(
                    controller: _phoneNumberCnt,
                    inputFormatters: [
                      PhoneNumberFormatter(),
                    ],
                    maxlength: 13,
                    title: '휴대전화',
                    validator: InputValidator().validatePhoneNumber,
                  ),
                const Gap(30),
                Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      Container(
                        height: 47,
                        constraints: const BoxConstraints(minWidth: 100),
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
                      Container(
                        height: 47,
                        constraints: const BoxConstraints(minWidth: 100),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            _updateApplicationStatus();
                          },
                          child: _updating ? const ButtonCircularProgressIndicator() : const Text("저장"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateApplicationStatus() async {
    _updating = true;
    if (_selectedStatusCode.isEmpty) _statusErrorCode = "상태를 선택하세요.";

    setState(() {});

    if (_formKey.currentState!.validate() && _selectedStatusCode.isNotEmpty) {
      final APIService apiService = APIService();
      var result = await apiService.updateApplicationStatus(
        context: context,
        requestModel: ApplicationStatusUpdatemodel(
          actNo: widget.applicationID,
          phoneNumber: _phoneNumberCnt.text,
          usimActStatus: _selectedStatusCode,
        ),
      );

      if (result) {
        if (widget.callBack != null) widget.callBack!();
        if (mounted) context.pop();
      }
    }

    _updating = false;
    setState(() {});
  }
}
