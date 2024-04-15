double desktopBreakPoint = 700;

const List countryNameCodelist = [
  {"code": 'CN', "label": '중국'},
  {"code": 'VN', "label": '베트남'},
  {"code": 'ID', "label": '인도네시아'},
  {"code": 'KH', "label": '캄보디아'},
  {"code": 'MN', "label": '몽골'},
  {"code": 'MM', "label": '미얀마'},
  {"code": 'TH', "label": '태국'},
  {"code": 'PH', "label": '필리핀'},
  {"code": 'HK', "label": '홍콩'},
  {"code": 'NP', "label": '네팔'},
  {"code": 'TW', "label": '대만'},
  {"code": 'BD', "label": '방글라데시'},
  {"code": 'LK', "label": '스리랑카'},
  {"code": 'ID', "label": '인도'},
  {"code": 'MY', "label": '말레이시아'},
  {"code": 'UZ', "label": '우즈베키스탄'},
  {"code": 'KZ', "label": '카자흐스탄'},
  {"code": 'RU', "label": '러시아'},
  {"code": 'US', "label": '미국'},
  {"code": 'KR', "label": '대한민국'},
];

final List<int> perPageCounts = [10, 20, 50, 100, 200];

final List<Map<String, dynamic>> userRolesList = [
  {
    "id": 1,
    "label": "관리자",
    "code": "ROLE_ADMIN",
    "state": 'active',
    "checked": false,
    "high": [],
    "low": ["ALL"]
  },
  {
    "id": 2,
    "label": "담당자",
    "code": "ROLE_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_USER", "ROLE_OPEN_MANAGER", "ROLE_OPEN_MEMBER", "ROLE_EXP_MANAGER", "ROLE_EXP_MEMBER", "ROLE_MALL_MANAGER", "ROLE_MALL_MEMBER"]
  },
  {
    "id": 3,
    "label": "사용자",
    "code": "ROLE_USER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER"],
    "low": ["ROLE_OPEN_MEMBER", "ROLE_EXP_MEMBER", "ROLE_MALL_MEMBER"]
  },

  //
  //개통
  {
    "id": 4,
    "label": "개통관리자",
    "code": "ROLE_OPEN_ADMIN",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_OPEN_MANAGER", "ROLE_OPEN_MEMBER"]
  },
  {
    "id": 5,
    "label": "개통담당자",
    "code": "ROLE_OPEN_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_OPEN_ADMIN"],
    "low": ["ROLE_OPEN_MEMBER"]
  },
  {
    "id": 6,
    "label": "개통사용자",
    "code": "ROLE_OPEN_MEMBER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_USER", "ROLE_OPEN_ADMIN", "ROLE_OPEN_MANAGER"],
    "low": []
  },

  //
  //해외배송
  {
    "id": 7,
    "label": "해외배송관리자",
    "code": "ROLE_EXP_ADMIN",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_EXP_MANAGER", "ROLE_EXP_MEMBER"]
  },
  {
    "id": 8,
    "label": "해외배송담당자",
    "code": "ROLE_EXP_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_EXP_ADMIN"],
    "low": ["ROLE_EXP_MEMBER"]
  },
  {
    "id": 9,
    "label": "해외배송사용자",
    "code": "ROLE_EXP_MEMBER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_USER", "ROLE_EXP_ADMIN", "ROLE_EXP_MANAGER"],
    "low": []
  },

  //
  //쇼핑몰
  {
    "id": 10,
    "label": "쇼핑몰관리자",
    "code": "ROLE_MALL_ADMIN",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN"],
    "low": ["ROLE_MALL_MANAGER", "ROLE_MALL_MEMBER"]
  },
  {
    "id": 11,
    "label": "쇼핑몰담당자",
    "code": "ROLE_MALL_MANAGER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_MALL_ADMIN"],
    "low": ["ROLE_MALL_MEMBER"]
  },
  {
    "id": 12,
    "label": "쇼핑몰사용자",
    "code": "ROLE_MALL_MEMBER",
    "state": 'active',
    "checked": false,
    "high": ["ROLE_ADMIN", "ROLE_MANAGER", "ROLE_USER", "ROLE_MALL_ADMIN", "ROLE_MALL_MANAGER"],
    "low": []
  },
];