import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/user_model.dart';
import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/formatters.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/presentation/components/alert_dialog.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/manage_users_popup_context.dart';
import 'package:admin_simpass/presentation/components/pagination.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final List<UserModel> _usersList = [];

  int _totalCount = 0;

  int _currentPage = 1;
  int _perPage = perPageCounts[0];

  bool _dataLoading = true;

  @override
  void initState() {
    _fetchUsers();
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.yellow.shade50,
          width: 800,
          child: const ManageUsersPopupContent(
            userId: 19,
            userName: 'openadm',
          ),
        ),
        const Header(title: "Users"),
        _dataLoading
            ? const CircularProgressIndicator()
            : Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(20),
                            SizedBox(
                              // width: 500,
                              child: Pagination(
                                totalCount: _totalCount,
                                onUpdated: (currentPage, perPage) async {
                                  if (currentPage != _currentPage || perPage != _perPage) {
                                    _currentPage = currentPage;
                                    _perPage = perPage;
                                    _usersList.clear();
                                    await _fetchUsers();
                                  }
                                },
                              ),
                            ),
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
                                border: TableBorder.all(
                                  color: Colors.transparent, // Make border color transparent
                                  width: 0,
                                ),
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
                                    // onSelectChanged: (value) {},

                                    cells: List.generate(
                                      _columns.length,
                                      (columnIndex) {
                                        if (columnIndex == 0) {
                                          return DataCell(
                                            Text(_usersList[rowIndex].id.toString()),
                                            onTap: () async {},
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
                                            Text(CustomFormat().formatDate(_usersList[rowIndex].fromDate) ?? ""),
                                            onTap: () {},
                                          );
                                        }
                                        if (columnIndex == 8) {
                                          return DataCell(
                                            const Icon(Icons.edit_outlined, color: MainUi.mainColor),
                                            onTap: () {
                                              showCustomDialog(
                                                width: 800,
                                                content: SizedBox(
                                                  // width: 500,
                                                  // height: 600,
                                                  child: ManageUsersPopupContent(
                                                    userId: _usersList[rowIndex].id,
                                                    userName: _usersList[rowIndex].username,
                                                  ),
                                                ),
                                                context: context,
                                              );
                                            },
                                          );
                                        }

                                        return DataCell(onTap: () {}, const SizedBox());
                                      },
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
                ),
              ),
      ],
    );
  }

  Future<void> _fetchUsers() async {
    // List<UserModel> newList = ROWS.map((json) => UserModel.fromJson(json)).toList();
    // _usersList.addAll(newList);
    // setState(() {});

    if (_currentPage == 1) _usersList.clear();

    final APIService apiService = APIService();
    var result = await apiService.fetchUsers(context: context, page: _currentPage, rowLimit: _perPage);

    if (result['data'] != null && result['data']['result'] == 'SUCCESS') {
      Map data = result['data'];
      List rows = data['rows'];
      _totalCount = data['totalNum'];

      List<UserModel> newList = rows.map((json) => UserModel.fromJson(json)).toList();
      _usersList.addAll(newList);

      _dataLoading = false;
    }
    setState(() {});
  }
}
