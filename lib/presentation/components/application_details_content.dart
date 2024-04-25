import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/applications_model.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/image_viewer_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ApplicationDetailsContent extends StatefulWidget {
  final String applicationId;
  const ApplicationDetailsContent({super.key, required this.applicationId});

  @override
  State<ApplicationDetailsContent> createState() => _ApplicationDetailsContentState();
}

class _ApplicationDetailsContentState extends State<ApplicationDetailsContent> {
  ApplicationDetailsModel? _details;
  bool _loading = true;

  List _base64ImagesList = [];

  @override
  void initState() {
    super.initState();
    _fetchApplicationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: _details == null
                  ? const Center(
                      child: Text('Data fetching error'),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('접수번호 : '),
                                  Flexible(
                                    child: Text(
                                      _details!.actNo ?? "",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('판매점명 : '),
                                  Flexible(
                                    child: Text(
                                      _details!.agentNm ?? "",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),
                        const Text(
                          '가입신청/고객정보',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(15),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '서비스유형',
                                initialValue: _details!.carrierTypeNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '통신사',
                                initialValue: _details!.carrierNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '고객정보',
                                initialValue: _details!.custTypeNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '고객정보',
                                initialValue: _details!.custNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: CustomTextInput(
                                title: '이름',
                                initialValue: _details!.name,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '연락처',
                                initialValue: _details!.contact,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '생년월일',
                                initialValue: _details!.birthday,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '신분증/여권번호',
                                initialValue: _details!.idNo,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '국적',
                                initialValue: _details!.countryCd,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: CustomTextInput(
                                title: '주소(주소+상세주소)',
                                initialValue: _details!.address,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        const Text(
                          '요금제',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(15),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: CustomTextInput(
                                title: '요금제 명',
                                initialValue: _details!.usimPlanNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '유심비용청구',
                                initialValue: _details!.usimFeeNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: 'USIM 모델명',
                                initialValue: _details!.usimModelNo,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '일련번호',
                                initialValue: _details!.usimNo,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '개통구분',
                                initialValue: _details!.usimActNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '가입/이동 전화번호',
                                initialValue: _details!.phoneNumber,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '희망번호 1',
                                initialValue: _details!.requestNo1,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '희망번호 2',
                                initialValue: _details!.requestNo2,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '희망번호 3',
                                initialValue: _details!.requestNo3,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        const Text(
                          '자동이체',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(15),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '결제구분',
                                initialValue: _details!.paidTransferNm,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: CustomTextInput(
                                title: '예금주명',
                                initialValue: _details!.accountName,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '예금주 생년월일',
                                initialValue: _details!.accountBirthday,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '은행(카드사)명',
                                initialValue: _details!.accountAgency,
                                enabled: false,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: CustomTextInput(
                                title: '은행(카드사)명',
                                initialValue: _details!.accountNumber,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const Gap(40),
                        SizedBox(
                          height: 47,
                          width: 100,
                          child: OutlinedButton(
                            onPressed: () async {
                              await _fetchApplicationImages();
                              if (_base64ImagesList.isNotEmpty && context.mounted) {
                                showDialog(
                                  barrierColor: Colors.black,
                                  context: context,
                                  builder: (context) => ImageViewerContent(binaryImageList: _base64ImagesList),
                                );
                              }
                            },
                            child: const Text('증빙자료'),
                          ),
                        ),
                        const Gap(40),
                      ],
                    ),
            ),
    );
  }

  Future<void> _fetchApplicationDetails() async {
    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchApplicationDetails(
        context: context,
        applicationId: widget.applicationId,
      );
      _details = result;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _loading = false;
    setState(() {});
  }

  Future<void> _fetchApplicationImages() async {
    try {
      final APIService apiService = APIService();
      var result = await apiService.fetchApplicationAttachs(
        context: context,
        applicationId: widget.applicationId,
      );
      _base64ImagesList = result;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
