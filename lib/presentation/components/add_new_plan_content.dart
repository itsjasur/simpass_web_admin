import 'package:admin_simpass/data/models/plans_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/button_circular_indicator.dart';
import 'package:admin_simpass/presentation/components/custom_menu_drop_down.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddNewPlanContent extends StatefulWidget {
  final ManagePlansModel info;
  const AddNewPlanContent({super.key, required this.info});

  @override
  State<AddNewPlanContent> createState() => _AddNewPlanContentState();
}

class _AddNewPlanContentState extends State<AddNewPlanContent> {
  String _selectedCarrierCode = "";
  String _selectedMvnoCode = "";
  String _selectedAgentCode = "";
  String _selectedPlanTypeCode = "";
  String _selectedSubscriberTargetCode = "";
  String _selectedStatusCode = "";

  final TextEditingController _selectedCarrierCodeCntr = TextEditingController();
  final TextEditingController _selectedMvnoCodeCntr = TextEditingController();
  final TextEditingController _selectedAgentCodeCntr = TextEditingController();
  final TextEditingController _selectedPlanTypeCodeCntr = TextEditingController();
  final TextEditingController _selectedSubscriberTargetCodeCntr = TextEditingController();
  final TextEditingController _selectedStatusCodeCntr = TextEditingController();

  String? _selectedCarrierCodeErr;
  String? _selectedMvnoCodeErr;
  String? _selectedAgentCodeErr;
  String? _selectedPlanTypeCodeErr;
  String? _selectedSubscriberTargetCodeErr;
  String? _selectedStatusCodeErr;

  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _baseAmountController = TextEditingController();
  final TextEditingController _saleAmountController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _voiceController = TextEditingController();
  final TextEditingController _videoEtcController = TextEditingController();
  final TextEditingController _qosController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  List<DropdownMenuEntry> _carriers = [];
  List<DropdownMenuEntry> _mvnos = [];
  List<DropdownMenuEntry> _agents = [];
  List<DropdownMenuEntry> _planTypes = [];
  List<DropdownMenuEntry> _subscriberTarget = [];
  List<DropdownMenuEntry> _statuses = [];

  final List<Map<String, dynamic>> _userRolesList = userRolesList;
  final _formKey = GlobalKey<FormState>();

  bool _dataUpdating = false;

  @override
  void initState() {
    super.initState();

    _carriers = widget.info.carrierCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _mvnos = widget.info.mvnoCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _agents = widget.info.agentCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _planTypes = widget.info.carrierType.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _subscriberTarget = widget.info.carrierPlanType.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
    _statuses = widget.info.statusCd.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();

    //listener should come before model parsing to local variables
    _selectedCarrierCodeCntr.addListener(() {
      if (_selectedCarrierCodeCntr.text.isEmpty) _selectedCarrierCode = "";
    });

    _selectedMvnoCodeCntr.addListener(() {
      if (_selectedMvnoCodeCntr.text.isEmpty) _selectedMvnoCode = "";
    });

    _selectedAgentCodeCntr.addListener(() {
      if (_selectedAgentCodeCntr.text.isEmpty) _selectedAgentCode = "";
    });

    _selectedPlanTypeCodeCntr.addListener(() {
      if (_selectedPlanTypeCodeCntr.text.isEmpty) _selectedPlanTypeCode = "";
    });

    _selectedSubscriberTargetCodeCntr.addListener(() {
      if (_selectedSubscriberTargetCodeCntr.text.isEmpty) _selectedSubscriberTargetCode = "";
    });

    _selectedStatusCodeCntr.addListener(() {
      if (_selectedStatusCodeCntr.text.isEmpty) _selectedStatusCode = "";
    });
  }

  @override
  void dispose() {
    _planNameController.dispose();
    _baseAmountController.dispose();
    _saleAmountController.dispose();
    _smsController.dispose();
    _dataController.dispose();
    _voiceController.dispose();
    _videoEtcController.dispose();
    _qosController.dispose();
    _priorityController.dispose();

    _selectedCarrierCodeCntr.dispose();
    _selectedMvnoCodeCntr.dispose();
    _selectedAgentCodeCntr.dispose();
    _selectedPlanTypeCodeCntr.dispose();
    _selectedSubscriberTargetCodeCntr.dispose();
    _selectedStatusCodeCntr.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              const Text(
                "신규 요금제 등록",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(30),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 15,
                runSpacing: 15,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        label: const Text("통신사"),
                        controller: _selectedCarrierCodeCntr,
                        requestFocusOnTap: true,
                        enableSearch: true,
                        enableFilter: true,
                        errorText: _selectedCarrierCodeErr,
                        items: _carriers,
                        onSelected: (selectedItem) {
                          print(selectedItem);
                          _selectedCarrierCode = selectedItem;
                          _selectedCarrierCodeErr = null;

                          setState(() {});
                        },
                        width: constraints.maxWidth,
                        selectedItem: _selectedCarrierCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        requestFocusOnTap: true,
                        enableSearch: true,
                        controller: _selectedMvnoCodeCntr,
                        enableFilter: true,
                        label: const Text("브랜드"),
                        errorText: _selectedMvnoCodeErr,
                        onSelected: (selectedItem) {
                          _selectedMvnoCodeErr = null;
                          _selectedMvnoCode = selectedItem;

                          if (mounted) setState(() {});
                        },
                        items: _mvnos,
                        width: constraints.maxWidth,
                        selectedItem: _selectedMvnoCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        requestFocusOnTap: true,
                        enableSearch: true,
                        controller: _selectedAgentCodeCntr,
                        enableFilter: true,
                        errorText: _selectedAgentCodeErr,
                        label: const Text("대리점"),
                        onSelected: (selectedItem) {
                          _selectedAgentCodeErr = null;
                          _selectedAgentCode = selectedItem;
                          setState(() {});
                        },
                        items: _agents,
                        width: constraints.maxWidth,
                        selectedItem: _selectedAgentCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        requestFocusOnTap: true,
                        enableSearch: true,
                        controller: _selectedPlanTypeCodeCntr,

                        errorText: _selectedPlanTypeCodeErr,
                        // enableFilter: true,
                        label: const Text("서비스 유형"),
                        onSelected: (selectedItem) {
                          _selectedPlanTypeCodeErr = null;
                          _selectedPlanTypeCode = selectedItem;
                          setState(() {});
                        },
                        items: _planTypes,
                        width: constraints.maxWidth,
                        selectedItem: _selectedPlanTypeCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        requestFocusOnTap: true,
                        controller: _selectedSubscriberTargetCodeCntr,
                        enableSearch: true,
                        enableFilter: true,
                        label: const Text("요금제 가입구분"),
                        errorText: _selectedSubscriberTargetCodeErr,
                        onSelected: (selectedItem) {
                          _selectedSubscriberTargetCodeErr = null;
                          _selectedSubscriberTargetCode = selectedItem;
                          setState(() {});
                        },
                        items: _subscriberTarget,
                        width: constraints.maxWidth,
                        selectedItem: _selectedSubscriberTargetCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: CustomTextInput(
                      controller: _planNameController,
                      title: '요금제명',
                      validator: (value) => InputValidator().validateForNoneEmpty(value, '요금제명'),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => CustomDropDownMenu(
                        requestFocusOnTap: true,
                        enableSearch: true,
                        enableFilter: true,
                        errorText: _selectedStatusCodeErr,
                        label: const Text("상태"),
                        controller: _selectedStatusCodeCntr,
                        onSelected: (selectedItem) {
                          _selectedStatusCode = selectedItem;
                          _selectedStatusCodeErr = null;
                          setState(() {});
                        },
                        items: _subscriberTarget,
                        width: constraints.maxWidth,
                        selectedItem: _selectedStatusCode,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _baseAmountController,
                      title: '기본료',
                      validator: (value) => InputValidator().validateForNoneEmpty(value, '기본료'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _saleAmountController,
                      title: '판매금액',
                      validator: (value) => InputValidator().validateForNoneEmpty(value, '판매금액'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _smsController,
                      title: '문자',
                      validator: (value) => InputValidator().validateForNoneEmpty(value, '문자'),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _dataController,
                      title: '데이터',
                      validator: (value) => InputValidator().validateForNoneEmpty(value, '데이터'),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _voiceController,
                      title: '음성',
                      validator: (value) => InputValidator().validateForNoneEmpty(value, '음성'),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _videoEtcController,
                      title: '영상/기타',
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _qosController,
                      title: 'QOS',
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: CustomTextInput(
                      controller: _priorityController,
                      title: '우선순위',
                    ),
                  ),
                ],
              ),
              const Gap(40),
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runSpacing: 20,
                  spacing: 20,
                  children: [
                    Container(
                      height: 47,
                      width: 100,
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
                        onPressed: _dataUpdating
                            ? null
                            : () {
                                print('button clicked');
                                bool errs = _checkDropDownValues();
                                bool form = _formKey.currentState!.validate();

                                if (errs && form) {
                                  print('read to upload');
                                }
                                setState(() {});
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
      ),
    );
  }

  bool _checkDropDownValues() {
    _selectedCarrierCodeErr = _selectedCarrierCode.isEmpty ? "통신사 선택하세요." : null;
    _selectedMvnoCodeErr = _selectedMvnoCode.isEmpty ? "브랜드 선택하세요." : null;
    _selectedAgentCodeErr = _selectedAgentCode.isEmpty ? "대리점 선택하세요." : null;
    _selectedPlanTypeCodeErr = _selectedPlanTypeCode.isEmpty ? "서비스 유형 선택하세요." : null;
    _selectedSubscriberTargetCodeErr = _selectedSubscriberTargetCode.isEmpty ? "요금제 가입구분 선택하세요." : null;
    _selectedStatusCodeErr = _selectedStatusCode.isEmpty ? "상태 입력하세요." : null;

    List errs = [
      _selectedCarrierCodeErr,
      _selectedMvnoCodeErr,
      _selectedAgentCodeErr,
      _selectedPlanTypeCodeErr,
      _selectedSubscriberTargetCodeErr,
      _selectedStatusCodeErr,
    ];

    return errs.every((err) => err == null);
  }
}
