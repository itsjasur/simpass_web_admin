class MemberModel {
  int? regBy;
  String? regTime;
  int? updateBy;
  String? updateTime;
  int id;
  String username;
  String? password;
  String? name;
  String? country;
  String? countryNm;
  String? phoneNumber;
  String? email;
  String? fromDate;
  String? expireDate;
  String? status;
  String? statusNm;
  List<dynamic>? roles;
  List<dynamic>? strRoles;
  Map<String, dynamic>? countryValue;
  Map<String, dynamic>? statusValue;
  List<dynamic>? rolesValue;

  MemberModel({
    this.regBy,
    this.regTime,
    this.updateBy,
    this.updateTime,
    required this.id,
    required this.username,
    this.password,
    this.name,
    this.country,
    this.countryNm,
    this.phoneNumber,
    this.email,
    this.fromDate,
    this.expireDate,
    this.status,
    this.statusNm,
    this.roles,
    this.strRoles,
    this.countryValue,
    this.statusValue,
    this.rolesValue,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      regBy: json['reg_by'] ?? 0,
      regTime: json['reg_time'] ?? "",
      updateBy: json['update_by'] ?? 0,
      updateTime: json['update_time'] ?? "",
      password: json['password'] ?? "",
      country: json['country'] ?? "",
      countryNm: json['country_nm'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      fromDate: json['from_date'] ?? "",
      expireDate: json['expire_date'] ?? "",
      status: json['status'] ?? "",
      statusNm: json['status_nm'] ?? "",
      roles: json['roles'] ?? "",
      strRoles: json['strRoles'] ?? "",
      countryValue: json['country_value'] ?? {},
      statusValue: json['status_value'] ?? [],
      rolesValue: json['roles_value'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'status': status,
      'from_date': fromDate,
      'expire_date': expireDate,
      'phone_number': phoneNumber,
      'country': country,
      'strRoles': strRoles,
    };
  }
}
