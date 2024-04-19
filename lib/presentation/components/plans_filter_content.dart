import 'package:admin_simpass/data/models/plans_model.dart';
import 'package:admin_simpass/presentation/components/custom_menu_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ManagePlansFilterContent extends StatefulWidget {
  final ManagePlansModel info;
  final ManagePlansRequestModel? requestModel;
  final Function(ManagePlansRequestModel)? onApply;
  const ManagePlansFilterContent({super.key, this.onApply, this.requestModel, required this.info});

  @override
  State<ManagePlansFilterContent> createState() => _ManagePlansFilterContentState();
}

class _ManagePlansFilterContentState extends State<ManagePlansFilterContent> {
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

  late List<DropdownMenuEntry> _carriers;
  late List<DropdownMenuEntry> _mvnos;
  late List<DropdownMenuEntry> _agents;
  late List<DropdownMenuEntry> _planTypes;
  late List<DropdownMenuEntry> _subscriberTarget;
  late List<DropdownMenuEntry> _statuses;

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

    if (widget.requestModel != null) {
      ManagePlansRequestModel model = widget.requestModel!;
      _selectedCarrierCode = model.carrierCd;
      _selectedMvnoCode = model.mvnoCd;
      _selectedAgentCode = model.agentCd;
      _selectedPlanTypeCode = model.carrierType;
      _selectedSubscriberTargetCode = model.carrierPlanType;
      _selectedStatusCode = model.status;
    }
  }

  @override
  void dispose() {
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
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "데이터 필터링",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(20),
            Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 15,
              runSpacing: 15,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 150,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => CustomDropDownMenu(
                      label: const Text("통신사"),
                      requestFocusOnTap: true,
                      enableSearch: true,
                      enableFilter: true,
                      controller: _selectedCarrierCodeCntr,
                      items: _carriers,
                      onSelected: (selectedItem) {
                        _selectedCarrierCode = selectedItem;
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
                      enableFilter: true,
                      controller: _selectedMvnoCodeCntr,
                      label: const Text("브랜드"),
                      onSelected: (selectedItem) {
                        _selectedMvnoCode = selectedItem;
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
                      label: const Text("대리점"),
                      onSelected: (selectedItem) {
                        _selectedAgentCode = selectedItem;
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
                      // enableFilter: true,
                      label: const Text("서비스 유형"),
                      onSelected: (selectedItem) {
                        _selectedPlanTypeCode = selectedItem;
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
                      enableSearch: true,
                      controller: _selectedSubscriberTargetCodeCntr,
                      enableFilter: true,
                      label: const Text("가입대상"),
                      onSelected: (selectedItem) {
                        _selectedSubscriberTargetCode = selectedItem;
                      },
                      items: _subscriberTarget,
                      width: constraints.maxWidth,
                      selectedItem: _selectedSubscriberTargetCode,
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 150,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => CustomDropDownMenu(
                      requestFocusOnTap: true,
                      enableSearch: true,
                      controller: _selectedStatusCodeCntr,
                      enableFilter: true,
                      label: const Text("상태"),
                      onSelected: (selectedItem) {
                        _selectedStatusCode = selectedItem;
                      },
                      items: _statuses,
                      width: constraints.maxWidth,
                      selectedItem: _selectedStatusCode,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(30),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 15,
              runSpacing: 15,
              children: [
                SizedBox(
                  height: 47,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black26,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text("취소"),
                  ),
                ),
                SizedBox(
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () {
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('pop up')));
                      if (widget.onApply != null) {
                        widget.onApply!(
                          ManagePlansRequestModel(
                            usimPlanNm: '',
                            carrierCd: _selectedCarrierCode,
                            mvnoCd: _selectedMvnoCode,
                            agentCd: _selectedAgentCode,
                            carrierPlanType: _selectedSubscriberTargetCode,
                            carrierType: _selectedPlanTypeCode,
                            status: _selectedStatusCode,
                            page: 1,
                            rowLimit: 10,
                          ),
                        );
                      }

                      context.pop();
                    },
                    child: const Text("검색"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
