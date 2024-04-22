import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/globals/validators.dart';
import 'package:admin_simpass/presentation/components/application_status_update_content.dart';
import 'package:admin_simpass/presentation/components/custom_alert_dialog.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => RApplicationsPageState();
}

class RApplicationsPageState extends State<ApplicationsPage> {
  bool _dataLoading = true;

  final List<DropdownMenuEntry> _searchTypes = applicationsSearchTypeList.map((item) => DropdownMenuEntry(value: item['code'], label: item['label'])).toList();
  String _selectedSearchType = applicationsSearchTypeList[0]['code'];

  final TextEditingController _fromDateCntr = TextEditingController(text: CustomFormat().formatDate(DateTime.now().subtract(const Duration(days: 7)).toString()));
  final TextEditingController _toDateCntr = TextEditingController(text: CustomFormat().formatDate(DateTime.now().toString()));

  final TextEditingController _statusCnt = TextEditingController();
  final ScrollController _horizontalScrolCntr = ScrollController();

  late List<DropdownMenuEntry> _statusesList;
  String _selectedStatusCode = "";

  final List _columns = applicationsColumns;

  List<ApplicationModel> _applicationsList = [];

  int _totalCount = 0;
  int _currentPage = 1;
  int _perPage = perPageCounts[0];

  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();

    _fetchApplications();

    _statusCnt.addListener(() {
      _selectedStatusCode = "";
      _fetchApplications();
    });
  }

  @override
  void dispose() {
    _fromDateCntr.dispose();
    _toDateCntr.dispose();
    _statusCnt.dispose();
    _horizontalScrolCntr.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(title: "신청서 접수현황"),
        _dataLoading
            ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 20,
                            runSpacing: 10,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200,
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) => CustomDropDownMenu(
                                    label: const Text("검색 선택"),
                                    items: _searchTypes,
                                    width: constraints.maxWidth,
                                    selectedItem: _selectedSearchType,
                                    onSelected: (selectedItem) {
                                      _selectedSearchType = selectedItem;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              if (_selectedSearchType == 'applyDate' || _selectedSearchType == 'regisDate')
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => CustomTextInput(
                                      title: _selectedSearchType == 'applyDate' ? '접수일자 (From)' : "개통일자 (From)",
                                      controller: _fromDateCntr,
                                      maxlength: 10,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                                        DateFormatter(),
                                      ],
                                      validator: InputValidator().validateDate,
                                    ),
                                  ),
                                ),
                              if (_selectedSearchType == 'applyDate' || _selectedSearchType == 'regisDate')
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => CustomTextInput(
                                      title: _selectedSearchType == 'applyDate' ? '접수일자 (To)' : "개통일자 (To)",
                                      controller: _toDateCntr,
                                      maxlength: 10,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                                        DateFormatter(),
                                      ],
                                      validator: InputValidator().validateDate,
                                    ),
                                  ),
                                ),
                              if (_selectedSearchType == 'status' && _statusesList.isNotEmpty)
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => CustomDropDownMenu(
                                      controller: _statusCnt,
                                      label: const Text("상태"),
                                      items: _statusesList,
                                      enableSearch: true,
                                      // enableFilter: true,
                                      requestFocusOnTap: true,
                                      width: constraints.maxWidth,
                                      selectedItem: _selectedStatusCode,
                                      onSelected: (selectedItem) {
                                        _selectedStatusCode = selectedItem;
                                      },
                                    ),
                                  ),
                                ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 120),
                                height: 47,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _fetchApplications();
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.search_outlined,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                      SizedBox(width: 5),
                                      Text("검색"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Pagination(
                            totalCount: _totalCount,
                            onUpdated: (currentPage, perPage) async {
                              if (currentPage != _currentPage || perPage != _perPage) {
                                _currentPage = currentPage;
                                _perPage = perPage;
                                await _fetchApplications();
                              }
                            },
                          ),
                        ),
                        const Gap(20),
                        Scrollbar(
                          controller: _horizontalScrolCntr,
                          scrollbarOrientation: ScrollbarOrientation.top,
                          child: Scrollbar(
                            controller: _horizontalScrolCntr,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            child: SingleChildScrollView(
                              controller: _horizontalScrolCntr,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth - 10,
                                ),
                                child: DataTable(
                                  sortColumnIndex: _sortColumnIndex,
                                  sortAscending: _sortAscending,
                                  showCheckboxColumn: false,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  border: TableBorder.all(
                                    color: Colors.transparent, // Make border color transparent
                                    width: 0,
                                  ),
                                  headingRowHeight: 50,
                                  columnSpacing: 40,

                                  // dataRowMinHeight: 40,
                                  // dataRowMaxHeight: 80,

                                  headingTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  columns: List.generate(
                                    _columns.length,
                                    (index) {
                                      return DataColumn(
                                        onSort: (columnIndex, ascending) {
                                          _sortAscending = ascending;
                                          _sortColumnIndex = columnIndex;

                                          void mysort<T>(Comparable<T> Function(ApplicationModel model) getField) {
                                            _applicationsList.sort((a, b) {
                                              final aValue = getField(a);
                                              final bValue = getField(b);

                                              return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
                                            });
                                          }

                                          // sorting table on tap on header
                                          if (columnIndex == 0) mysort((model) => model.num);
                                          if (columnIndex == 1) mysort((model) => model.partnerNm?.toLowerCase() ?? "");
                                          if (columnIndex == 2) mysort((model) => model.usimActStatus?.toLowerCase() ?? "");
                                          if (columnIndex == 3) mysort((model) => model.actNo?.toLowerCase() ?? "");
                                          if (columnIndex == 4) mysort((model) => model.name?.toLowerCase() ?? "");
                                          if (columnIndex == 5) mysort((model) => model.phoneNumber?.toLowerCase() ?? "");
                                          if (columnIndex == 8) mysort((model) => model.applyDate ?? "");
                                          if (columnIndex == 9) mysort((model) => model.actDate ?? "");

                                          setState(() {});
                                        },
                                        label: Text(_columns[index]),
                                      );
                                    },
                                  ),
                                  rows: List.generate(
                                    _applicationsList.length,
                                    (rowIndex) => DataRow(
                                      // onSelectChanged: (value) {},

                                      cells: List.generate(
                                        _columns.length,
                                        (columnIndex) {
                                          if (columnIndex == 0) {
                                            return DataCell(
                                              Text(_applicationsList[rowIndex].num.toString()),
                                              onTap: () async {},
                                            );
                                          }

                                          if (columnIndex == 1) {
                                            return DataCell(
                                              Container(
                                                constraints: const BoxConstraints(maxWidth: 150),
                                                child: Text(
                                                  _applicationsList[rowIndex].partnerNm ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              onTap: () {},
                                            );
                                          }

                                          if (columnIndex == 2) {
                                            bool editable = true;
                                            Color containerColor = Colors.grey;
                                            if (_applicationsList[rowIndex].usimActStatus == 'A') containerColor = Colors.blue;
                                            if (_applicationsList[rowIndex].usimActStatus == 'B') containerColor = Colors.green;
                                            if (_applicationsList[rowIndex].usimActStatus == 'P') containerColor = Colors.green;
                                            if (_applicationsList[rowIndex].usimActStatus == 'D') containerColor = Colors.red;
                                            if (_applicationsList[rowIndex].usimActStatus == 'W') containerColor = Colors.orange;
                                            if (_applicationsList[rowIndex].usimActStatus == 'C') containerColor = Colors.red;

                                            if (_applicationsList[rowIndex].usimActStatus == 'Y') {
                                              containerColor = Colors.grey;
                                              editable = false;
                                            }

                                            return DataCell(
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                constraints: const BoxConstraints(minWidth: 80),
                                                decoration: BoxDecoration(
                                                  color: containerColor,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      _applicationsList[rowIndex].usimActStatusNm ?? "",
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                    if (editable)
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 5),
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                if (editable) {
                                                  showCustomDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    content: ApplicationStatusUpdateContent(
                                                      items: _statusesList,
                                                      applicationID: _applicationsList[rowIndex].actNo ?? "",
                                                      callBack: _fetchApplications,
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          }

                                          if (columnIndex == 3) {
                                            return DataCell(
                                              Text(_applicationsList[rowIndex].actNo ?? ""),
                                              onTap: () {},
                                            );
                                          }
                                          if (columnIndex == 4) {
                                            return DataCell(
                                              Container(
                                                constraints: const BoxConstraints(maxWidth: 250),
                                                child: Text(
                                                  _applicationsList[rowIndex].name ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              onTap: () {},
                                            );
                                          }
                                          if (columnIndex == 5) {
                                            return DataCell(
                                              placeholder: false,
                                              Text(_applicationsList[rowIndex].phoneNumber ?? ""),
                                              onTap: () {},
                                            );
                                          }

                                          if (columnIndex == 6) {
                                            return DataCell(
                                              placeholder: false,
                                              OutlinedButton(onPressed: () {}, child: const Text('가입정보')),
                                              onTap: () {},
                                            );
                                          }

                                          if (columnIndex == 7) {
                                            return DataCell(
                                              placeholder: false,
                                              const Icon(
                                                Icons.file_present_outlined,
                                                color: MainUi.mainColor,
                                              ),
                                              onTap: () {},
                                            );
                                          }

                                          if (columnIndex == 8) {
                                            return DataCell(
                                              placeholder: false,
                                              Text(_applicationsList[rowIndex].applyDate ?? ""),
                                              onTap: () {},
                                            );
                                          }

                                          if (columnIndex == 9) {
                                            return DataCell(
                                              placeholder: false,
                                              Text(_applicationsList[rowIndex].actDate ?? ""),
                                              onTap: () {},
                                            );
                                          }

                                          if (columnIndex == 10) {
                                            return DataCell(
                                              placeholder: false,
                                              const Text("서명없음"),
                                              onTap: () {},
                                            );
                                          }

                                          return DataCell(onTap: () {}, const SizedBox());
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Future<void> _fetchApplications() async {
    try {
      final APIService apiService = APIService();

      var result = await apiService.fetchApplications(
        context: context,
        requestModel: ApplicationsRequestModel(
          actNo: "",
          usimActStatus: _selectedStatusCode,
          // applyFrDate: _selectedSearchType == 'applyDate' ? _fromDateCntr.text : "",
          // applyToDate: _selectedSearchType == 'applyDate' ? _toDateCntr.text : "",
          // actFrDate: _selectedSearchType == 'regisDate' ? _fromDateCntr.text : "",
          // actToDate: _selectedSearchType == 'regisDate' ? _toDateCntr.text : "",
          page: _currentPage,
          rowLimit: _perPage,
        ),
      );

      _totalCount = result.totalNum;
      _statusesList = result.usimActStatusCodes.map((e) => DropdownMenuEntry(value: e.cd, label: e.value)).toList();
      _applicationsList = result.applicationsList;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _dataLoading = false;
    setState(() {});
  }
}
