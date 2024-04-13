import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/user_mdel.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/pages/test.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  List<UserModel> _usersList = [];
  int _totalCount = 0;

  @override
  void initState() {
    _fetchUsers(1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List _columns = ['ID', 'Username', 'Name', 'Country', 'Phone number', 'Email', 'Status', 'Start date', 'Action'];

  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: "Users"),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    const Gap(20),
                    Container(
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

                        // dataRowColor: MaterialStatePropertyAll(Colors.blueAccent),
                        border: TableBorder.all(
                          color: Colors.transparent, // Make border color transparent
                          width: 0,
                        ),
                        // onSelectAll: (value) {},

                        dataRowMinHeight: 40,
                        columnSpacing: 40,
                        headingRowHeight: 50,
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

                                void mysort<T>(Comparable<T> Function(UserModel model) getField) {
                                  _usersList.sort((a, b) {
                                    final aValue = getField(a);
                                    final bValue = getField(b);

                                    return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
                                  });
                                }

                                if (columnIndex == 0) mysort((model) => model.id);
                                if (columnIndex == 1) mysort((model) => model.username.toLowerCase());
                                if (columnIndex == 2) mysort((model) => model.name.toLowerCase());
                                if (columnIndex == 3) _usersList.sort((a, b) => _sortAscending ? a.countryNm.compareTo(b.countryNm) : b.countryNm.compareTo(a.countryNm));
                                if (columnIndex == 6) _usersList.sort((a, b) => _sortAscending ? a.statusNm.compareTo(b.status) : b.statusNm.compareTo(a.statusNm));
                                if (columnIndex == 7) _usersList.sort((a, b) => _sortAscending ? a.fromDate.compareTo(b.fromDate) : b.fromDate.compareTo(a.fromDate));

                                setState(() {});
                              },
                              label: Text(_columns[index]),
                            );
                          },
                        ),
                        rows: List.generate(
                          _usersList.length,
                          (rowIndex) => DataRow(
                            onSelectChanged: (value) {},
                            cells: List.generate(
                              _columns.length,
                              (columnIndex) {
                                if (columnIndex == 0) {
                                  return DataCell(
                                    Text(_usersList[rowIndex].id.toString()),
                                    onTap: () {},
                                  );
                                }
                                if (columnIndex == 1) {
                                  return DataCell(
                                    Text(_usersList[rowIndex].username),
                                    onTap: () {},
                                  );
                                }
                                if (columnIndex == 2) {
                                  return DataCell(
                                    Text(_usersList[rowIndex].name),
                                    onTap: () {},
                                  );
                                }
                                if (columnIndex == 3) {
                                  return DataCell(
                                    Text(_usersList[rowIndex].countryNm),
                                    onTap: () {},
                                  );
                                }
                                if (columnIndex == 4) {
                                  return DataCell(
                                    Text(_usersList[rowIndex].phoneNumber),
                                    onTap: () {},
                                  );
                                }
                                if (columnIndex == 5) {
                                  return DataCell(
                                    placeholder: false,
                                    Text(_usersList[rowIndex].email),
                                    onTap: () {},
                                  );
                                }
                                if (columnIndex == 6) {
                                  if (_usersList[rowIndex].status == 'Y') {
                                    return DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            )),
                                        child: Text(
                                          _usersList[rowIndex].statusNm,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () {},
                                    );
                                  } else {}
                                }
                                if (columnIndex == 7) {
                                  return DataCell(
                                    Text(_usersList[rowIndex].fromDate),
                                    onTap: () {},
                                  );
                                }
                                if (columnIndex == 8) {
                                  return DataCell(
                                    const Icon(Icons.edit_outlined, color: MainUi.mainColor),
                                    onTap: () {},
                                  );
                                }

                                return DataCell(
                                  onTap: () {},
                                  const Text(''),
                                );
                              },
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
        ),
      ],
    );
  }

  Future<void> _fetchUsers(int page) async {
    List<UserModel> newList = ROWS.map((json) => UserModel.fromJson(json)).toList();

    _usersList.addAll(newList);

    setState(() {});

    // final APIService apiService = APIService();
    // var result = await apiService.fetchUsers(context: context, page: 1, rowLimit: 10);

    // if (result['data'] != null && result['data']['result'] == 'SUCCESS') {
    //   Map data = result['data'];
    //   List rows = data['rows'];
    //   _totalCount = data['totalNum'];

    //   List<UserModel> newList = rows.map((json) => UserModel.fromJson(json)).toList();
    //   _usersList.addAll(newList);

    //   setState(() {});
    // }

    // print(result);
  }
}
