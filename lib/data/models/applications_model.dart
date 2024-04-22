class ApplicationsInfoModel {
  final List<ApplicationModel> applicationsList;
  final List<ApplicationStatusesModel> usimActStatusCodes;
  final int lastPage;
  final int totalNum;
  final int rowLimit;
  final int currentPage;

  ApplicationsInfoModel({
    required this.applicationsList,
    required this.usimActStatusCodes,
    required this.lastPage,
    required this.totalNum,
    required this.rowLimit,
    required this.currentPage,
  });

  factory ApplicationsInfoModel.fromJson(Map<String, dynamic> map) {
    List<ApplicationModel> applicationsList = (map['act_list'] as List).map((e) => ApplicationModel.fromMap(e)).toList();
    List<ApplicationStatusesModel> usimActStatusCodes = (map['usim_act_status_code'] as List).map((e) => ApplicationStatusesModel.fromMap(e)).toList();

    return ApplicationsInfoModel(
      applicationsList: applicationsList,
      usimActStatusCodes: usimActStatusCodes,
      lastPage: map['lastPage'],
      totalNum: map['totalNum'],
      rowLimit: map['rowLimit'],
      currentPage: map['currentPage'],
    );
  }
}

class ApplicationStatusesModel {
  final String cd;
  final String value;

  ApplicationStatusesModel({
    required this.cd,
    required this.value,
  });

  factory ApplicationStatusesModel.fromMap(Map<String, dynamic> map) {
    return ApplicationStatusesModel(
      cd: map['cd'] ?? '',
      value: map['value'] ?? '',
    );
  }
}

class ApplicationModel {
  final int num;
  final String? actNo;
  final String? partnerCd;
  final String? partnerNm;
  final String? carrierType;
  final String? carrierTypeNm;
  final String? custType;
  final String? custTypeNm;
  final String? usimActCd;
  final String? usimActCdNm;
  final String? name;
  final String? phoneNumber;
  final String? usimPlanNm;
  final String? carrierCd;
  final String? carrierCdNm;
  final String? mvnoCd;
  final String? usimActStatus;
  final String? usimActStatusNm;
  final String? applyDate;
  final String? actDate;
  final String? signYn;
  final String? signYnNm;
  final String? applyForms;
  final String? attachFiles;
  final String? chkEqYn;

  ApplicationModel({
    required this.num,
    this.actNo,
    this.partnerCd,
    this.partnerNm,
    this.carrierType,
    this.carrierTypeNm,
    this.custType,
    this.custTypeNm,
    this.usimActCd,
    this.usimActCdNm,
    this.name,
    this.phoneNumber,
    this.usimPlanNm,
    this.carrierCd,
    this.carrierCdNm,
    this.mvnoCd,
    this.usimActStatus,
    this.usimActStatusNm,
    this.applyDate,
    this.actDate,
    this.signYn,
    this.signYnNm,
    this.applyForms,
    this.attachFiles,
    this.chkEqYn,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      num: map['num'],
      actNo: map['act_no'],
      partnerCd: map['partner_cd'],
      partnerNm: map['partner_nm'],
      carrierType: map['carrier_type'],
      carrierTypeNm: map['carrier_type_nm'],
      custType: map['cust_type'],
      custTypeNm: map['cust_type_nm'],
      usimActCd: map['usim_act_cd'],
      usimActCdNm: map['usim_act_cd_nm'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      usimPlanNm: map['usim_plan_nm'],
      carrierCd: map['carrier_cd'],
      carrierCdNm: map['carrier_cd_nm'],
      mvnoCd: map['mvno_cd'],
      usimActStatus: map['usim_act_status'],
      usimActStatusNm: map['usim_act_status_nm'],
      applyDate: map['apply_date'],
      actDate: map['act_date'],
      signYn: map['sign_yn'],
      signYnNm: map['sign_yn_nm'],
      applyForms: map['apply_forms'] ?? false,
      attachFiles: map['attach_files'] ?? false,
      chkEqYn: map['chk_eq_yn'],
    );
  }
}

class ApplicationsRequestModel {
  final String actNo;
  final String partnerCd;
  final String usimActStatus;
  final String applyFrDate;
  final String applyToDate;
  final String actFrDate;
  final String actToDate;
  final int page;
  final int rowLimit;

  ApplicationsRequestModel({
    this.actNo = "",
    this.partnerCd = "",
    this.usimActStatus = "",
    this.applyFrDate = "",
    this.applyToDate = "",
    this.actFrDate = "",
    this.actToDate = "",
    required this.page,
    required this.rowLimit,
  });

  // Method to convert the instance back to json
  Map<String, dynamic> toJson() {
    return {
      'act_no': actNo,
      'partner_cd': partnerCd,
      'usim_act_status': usimActStatus,
      'apply_fr_date': applyFrDate,
      'apply_to_date': applyToDate,
      'act_fr_date': actFrDate,
      'act_to_date': actToDate,
      'page': page,
      'rowLimit': rowLimit,
    };
  }
}

class ApplicationStatusUpdatemodel {
  final String actNo;
  final String phoneNumber;
  final String usimActStatus;

  ApplicationStatusUpdatemodel({
    this.actNo = "",
    this.phoneNumber = "",
    this.usimActStatus = "",
  });

  // Method to convert the instance back to json
  Map<String, dynamic> toJson() {
    return {
      "act_no": actNo,
      "phone_number": phoneNumber,
      "usim_act_status": usimActStatus,
    };
  }
}
