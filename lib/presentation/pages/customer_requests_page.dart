import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/customer_requests_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/presentation/components/custom_drop_down_menu.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/pagination.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomerRequestsPage extends StatefulWidget {
  const CustomerRequestsPage({super.key});

  @override
  State<CustomerRequestsPage> createState() => CustomerRequestsPageState();
}

class CustomerRequestsPageState extends State<CustomerRequestsPage> {
  bool _dataLoading = true;
  final ScrollController _horizontalScrolCntr = ScrollController();
  final List _columns = customerRequestsColumns;
  List<CustomerRequestModel> _customerRequestsList = [];

  int _totalCount = 0;
  int _currentPage = 1;
  int _perPage = perPageCounts[0];

  final TextEditingController _nameController = TextEditingController();

  String _selectedStatusCode = "";
  String _selectedCountrCode = "";

  int? _sortColumnIndex;
  bool _sortAscending = true;

  final List<CodeValue> _statusesList = [CodeValue(cd: '', value: '전체')];
  final List<CodeValue> _countriesList = [CodeValue(cd: '', value: '전체')];

  @override
  void initState() {
    super.initState();
    _fetchCustomerRequests();
  }

  @override
  void dispose() {
    _horizontalScrolCntr.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(title: "상담사 개통 문의현황"),
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
                                      label: const Text("상태"),
                                      items: _statusesList.map((e) => DropdownMenuEntry(value: e.cd ?? "", label: e.value ?? "")).toList(),
                                      width: constraints.maxWidth,
                                      menuHeight: 500,
                                      selectedItem: _selectedStatusCode,
                                      onSelected: (selectedItem) {
                                        _selectedStatusCode = selectedItem;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => CustomDropDownMenu(
                                      label: const Text("국가"),
                                      menuHeight: 500,
                                      items: _countriesList.map((e) => DropdownMenuEntry(value: e.cd ?? "", label: e.value ?? "")).toList(),
                                      width: constraints.maxWidth,
                                      selectedItem: _selectedCountrCode,
                                      onSelected: (selectedItem) {
                                        _selectedCountrCode = selectedItem;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) => CustomTextInput(
                                      title: "이름",
                                      controller: _nameController,
                                      maxlength: 10,
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(minWidth: 120),
                                  height: 47,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _fetchCustomerRequests();
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
                                  _fetchCustomerRequests();
                                }
                              },
                            ),
                          ),
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
                                    minWidth: constraints.maxWidth - 40,
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

                                            void mysort<T>(Comparable<T> Function(CustomerRequestModel model) getField) {
                                              _customerRequestsList.sort((a, b) {
                                                final aValue = getField(a);
                                                final bValue = getField(b);

                                                return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
                                              });
                                            }

                                            // sorting table on tap on header
                                            if (columnIndex == 0) mysort((model) => model.num ?? 0);
                                            if (columnIndex == 1) mysort((model) => model.name?.toLowerCase() ?? "");
                                            if (columnIndex == 2) mysort((model) => model.contact?.toLowerCase() ?? "");
                                            if (columnIndex == 3) mysort((model) => model.countryNm?.toLowerCase() ?? "");
                                            if (columnIndex == 4) mysort((model) => model.planId?.toLowerCase() ?? "");
                                            if (columnIndex == 5) mysort((model) => model.planNm?.toLowerCase() ?? "");
                                            if (columnIndex == 6) mysort((model) => model.usimActNm?.toLowerCase() ?? "");
                                            if (columnIndex == 7) mysort((model) => model.status?.toLowerCase() ?? "");

                                            setState(() {});
                                          },
                                          label: Text(_columns[index]),
                                        );
                                      },
                                    ),
                                    rows: List.generate(
                                      _customerRequestsList.length,
                                      (rowIndex) => DataRow(
                                        // onSelectChanged: (value) {},

                                        cells: List.generate(
                                          _columns.length,
                                          (columnIndex) {
                                            if (columnIndex == 0) {
                                              return DataCell(
                                                Container(
                                                  constraints: const BoxConstraints(maxWidth: 50),
                                                  child: Text(_customerRequestsList[rowIndex].num.toString()),
                                                ),
                                                onTap: () {},
                                              );
                                            }

                                            if (columnIndex == 1) {
                                              return DataCell(
                                                placeholder: false,
                                                Container(
                                                  constraints: const BoxConstraints(maxWidth: 350),
                                                  child: Text(
                                                    _customerRequestsList[rowIndex].name ?? "",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                onTap: () {},
                                              );
                                            }

                                            if (columnIndex == 2) {
                                              return DataCell(
                                                placeholder: false,
                                                Text(
                                                  _customerRequestsList[rowIndex].contact ?? "",
                                                ),
                                                onTap: () {},
                                              );
                                            }

                                            if (columnIndex == 3) {
                                              return DataCell(
                                                placeholder: false,
                                                Text(
                                                  _customerRequestsList[rowIndex].countryNm ?? "",
                                                ),
                                                onTap: () {},
                                              );
                                            }

                                            if (columnIndex == 4) {
                                              return DataCell(
                                                placeholder: false,
                                                Text(
                                                  _customerRequestsList[rowIndex].planNm ?? "",
                                                ),
                                                onTap: () {},
                                              );
                                            }

                                            if (columnIndex == 5) {
                                              return DataCell(
                                                placeholder: false,
                                                Text(
                                                  _customerRequestsList[rowIndex].usimActNm ?? "",
                                                ),
                                                onTap: () {},
                                              );
                                            }

                                            if (columnIndex == 6) {
                                              bool editable = true;
                                              Color containerColor = Colors.grey;
                                              if (_customerRequestsList[rowIndex].status == 'A') containerColor = Colors.blue;
                                              if (_customerRequestsList[rowIndex].status == 'B') containerColor = Colors.purple;
                                              if (_customerRequestsList[rowIndex].status == 'P') containerColor = Colors.green;
                                              if (_customerRequestsList[rowIndex].status == 'Y') containerColor = Colors.grey;
                                              if (_customerRequestsList[rowIndex].status == 'D') containerColor = Colors.red;
                                              if (_customerRequestsList[rowIndex].status == 'W') containerColor = Colors.red;
                                              if (_customerRequestsList[rowIndex].status == 'C') containerColor = Colors.red;

                                              return DataCell(
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                  constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
                                                  decoration: BoxDecoration(
                                                    color: containerColor,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text(
                                                        textAlign: TextAlign.center,
                                                        _customerRequestsList[rowIndex].statusNm ?? "",
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                      if (editable)
                                                        const Padding(
                                                          padding: EdgeInsets.only(left: 3),
                                                          child: Icon(
                                                            Icons.edit_outlined,
                                                            color: Colors.white,
                                                            size: 15,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
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
                          const Gap(100),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _fetchCustomerRequests() async {
    try {
      final APIService apiService = APIService();

      var result = await apiService.fetchCustomerRequests(
        context: context,
        requestModel: {
          "country_cd": _selectedCountrCode,
          "name": _nameController.text,
          "status": _selectedStatusCode,
          "page": _currentPage,
          "rowLimit": _perPage,
        },
      );

      _totalCount = result.totalNum ?? 0;
      _statusesList.addAll(result.statusList ?? []);
      _countriesList.addAll(result.countryList ?? []);
      _customerRequestsList = result.applyList ?? [];
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _dataLoading = false;
    setState(() {});
  }
}
