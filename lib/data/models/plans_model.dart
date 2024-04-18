class ManagePlansModel {
  final List<CarrierType> carrierType;
  final List<CodeNamePair> mvnoCd;
  final List<CodeNamePair> carrierPlanType;
  final int lastPage;
  final List<CodeNamePair> statusCd;
  final int totalNum;
  final List<CodeNamePair> agentCd;
  final List<CodeNamePair> carrierCd;
  final List<PlanModel> planList;
  final int rowLimit;
  final int currentPage;

  ManagePlansModel({
    required this.carrierType,
    required this.mvnoCd,
    required this.carrierPlanType,
    required this.lastPage,
    required this.statusCd,
    required this.totalNum,
    required this.agentCd,
    required this.carrierCd,
    required this.planList,
    required this.rowLimit,
    required this.currentPage,
  });

  factory ManagePlansModel.fromJson(Map<String, dynamic> json) {
    return ManagePlansModel(
      carrierType: List<CarrierType>.from(json['carrier_type'].map((x) => CarrierType.fromJson(x))),
      mvnoCd: List<CodeNamePair>.from(json['mvno_cd'].map((x) => CodeNamePair.fromJson(x))),
      carrierPlanType: List<CodeNamePair>.from(json['carrier_plan_type'].map((x) => CodeNamePair.fromJson(x))),
      lastPage: json['lastPage'],
      statusCd: List<CodeNamePair>.from(json['status_cd'].map((x) => CodeNamePair.fromJson(x))),
      totalNum: json['totalNum'],
      agentCd: List<CodeNamePair>.from(json['agent_cd'].map((x) => CodeNamePair.fromJson(x))),
      carrierCd: List<CodeNamePair>.from(json['carrier_cd'].map((x) => CodeNamePair.fromJson(x))),
      planList: List<PlanModel>.from(json['plan_list'].map((x) => PlanModel.fromJson(x))),
      rowLimit: json['rowLimit'],
      currentPage: json['currentPage'],
    );
  }
}

class CarrierType {
  final String cd;
  final String value;

  CarrierType({required this.cd, required this.value});

  factory CarrierType.fromJson(Map<String, dynamic> json) {
    return CarrierType(
      cd: json['cd'],
      value: json['value'],
    );
  }
}

class CodeNamePair {
  final String cd;
  final String value;

  CodeNamePair({required this.cd, required this.value});

  factory CodeNamePair.fromJson(Map<String, dynamic> json) {
    return CodeNamePair(
      cd: json['cd'],
      value: json['value'],
    );
  }
}

class PlanModel {
  int num;
  int id;
  String usimPlanNm;
  String carrierCd;
  String carrierNm;
  String mvnoCd;
  String mvnoNm;
  String agentCd;
  String agentNm;
  double basicFee;
  double salesFee;
  double discountFee;
  String voice;
  String message;
  String cellData;
  String videoEtc;
  String qos;
  String carrierPlanType;
  String carrierPlanTypeNm;
  String carrierType;
  String carrierTypeNm;
  double usimFee;
  double planFee;
  String fromDate;
  String expireDate;
  String status;
  String statusNm;
  int regBy;
  String regTime;
  int updateBy;
  String updateTime;

  PlanModel({
    this.num = 0,
    this.id = 0,
    this.usimPlanNm = '',
    this.carrierCd = '',
    this.carrierNm = '',
    this.mvnoCd = '',
    this.mvnoNm = '',
    this.agentCd = '',
    this.agentNm = '',
    this.basicFee = 0,
    this.salesFee = 0,
    this.discountFee = 0,
    this.voice = '',
    this.message = '',
    this.cellData = '',
    this.videoEtc = '',
    this.qos = '',
    this.carrierPlanType = '',
    this.carrierPlanTypeNm = '',
    this.carrierType = '',
    this.carrierTypeNm = '',
    this.usimFee = 0,
    this.planFee = 0,
    this.fromDate = '',
    this.expireDate = '',
    this.status = '',
    this.statusNm = '',
    this.regBy = 0,
    this.regTime = '',
    this.updateBy = 0,
    this.updateTime = '',
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      num: json['num'] ?? 0,
      id: json['id'] ?? 0,
      usimPlanNm: json['usim_plan_nm'] ?? '',
      carrierCd: json['carrier_cd'] ?? '',
      carrierNm: json['carrier_nm'] ?? '',
      mvnoCd: json['mvno_cd'] ?? '',
      mvnoNm: json['mvno_nm'] ?? '',
      agentCd: json['agent_cd'] ?? '',
      agentNm: json['agent_nm'] ?? '',
      basicFee: json['basic_fee'] ?? 0,
      salesFee: json['sales_fee'] ?? 0,
      discountFee: json['discount_fee'] ?? 0,
      voice: json['voice'] ?? '',
      message: json['message'] ?? '',
      cellData: json['cell_data'] ?? '',
      videoEtc: json['video_etc'] ?? '',
      qos: json['qos'] ?? '',
      carrierPlanType: json['carrier_plan_type'] ?? '',
      carrierPlanTypeNm: json['carrier_plan_type_nm'] ?? '',
      carrierType: json['carrier_type'] ?? '',
      carrierTypeNm: json['carrier_type_nm'] ?? '',
      usimFee: json['usim_fee'] ?? 0,
      planFee: json['plan_fee'] ?? 0,
      fromDate: json['from_date'] ?? '',
      expireDate: json['expire_date'] ?? '',
      status: json['status'] ?? '',
      statusNm: json['status_nm'] ?? '',
      regBy: json['reg_by'] ?? 0,
      regTime: json['reg_time'] ?? '',
      updateBy: json['update_by'] ?? 0,
      updateTime: json['update_time'] ?? '',
    );
  }
}

class ManagePlansRequestModel {
  String usimPlanNm; // 요금제명
  String carrierCd; // 통신사
  String mvnoCd; // 브랜드
  String agentCd; // 대리점
  String carrierPlanType; // 가입대상
  String carrierType; // 서비스유형
  String status; // 상태
  int page;
  int rowLimit;

  ManagePlansRequestModel({
    this.usimPlanNm = '',
    this.carrierCd = '',
    this.mvnoCd = '',
    this.agentCd = '',
    this.carrierPlanType = '',
    this.carrierType = '',
    this.status = '',
    this.page = 1,
    this.rowLimit = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'usim_plan_nm': usimPlanNm,
      'carrier_cd': carrierCd,
      'mvno_cd': mvnoCd,
      'agent_cd': agentCd,
      'carrier_plan_type': carrierPlanType,
      'carrier_type': carrierType,
      'status': status,
      'page': page,
      'rowLimit': rowLimit,
    };
  }

  ManagePlansRequestModel copyWith({
    String? usimPlanNm,
    String? carrierCd,
    String? mvnoCd,
    String? agentCd,
    String? carrierPlanType,
    String? carrierType,
    String? status,
    int? page,
    int? rowLimit,
  }) {
    return ManagePlansRequestModel(
      usimPlanNm: usimPlanNm ?? this.usimPlanNm,
      carrierCd: carrierCd ?? this.carrierCd,
      mvnoCd: mvnoCd ?? this.mvnoCd,
      agentCd: agentCd ?? this.agentCd,
      carrierPlanType: carrierPlanType ?? this.carrierPlanType,
      carrierType: carrierType ?? this.carrierType,
      status: status ?? this.status,
      page: page ?? this.page,
      rowLimit: rowLimit ?? this.rowLimit,
    );
  }

  // Method to check if any of the specified fields are not empty
  bool hasFilledFields() {
    return agentCd.isNotEmpty || carrierCd.isNotEmpty || carrierPlanType.isNotEmpty || carrierType.isNotEmpty || mvnoCd.isNotEmpty || status.isNotEmpty;
  }

  int? countNonEmptyFields() {
    List<String> fields = [
      carrierCd,
      mvnoCd,
      agentCd,
      carrierPlanType,
      carrierType,
      status,
    ];

    int count = fields.fold(0, (int sum, String field) => sum + (field.isNotEmpty ? 1 : 0));

    return count == 0 ? null : count;
  }
}
