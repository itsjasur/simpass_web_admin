import 'package:admin_simpass/data/api/api_service.dart';
import 'package:admin_simpass/data/models/retailers_model.dart';
import 'package:admin_simpass/presentation/components/custom_text_input.dart';
import 'package:admin_simpass/presentation/components/image_viewer_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RetailerDetailsContent extends StatefulWidget {
  final String id;
  const RetailerDetailsContent({super.key, required this.id});

  @override
  State<RetailerDetailsContent> createState() => _RetailerDetailsContentState();
}

class _RetailerDetailsContentState extends State<RetailerDetailsContent> {
  PartnerModel? _details;
  bool _loading = true;

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
                        const Text(
                          '상세정보',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const Gap(20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '판매점코드',
                                initialValue: _details?.partnerCd,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '대표자명',
                                initialValue: _details?.contractor,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '대표자 생년월일',
                                initialValue: _details?.birthday,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: CustomTextInput(
                                title: '판매점명',
                                initialValue: _details?.partnerNm,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '연락처',
                                initialValue: _details?.phoneNumber,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '사업자번호',
                                initialValue: _details?.businessNum,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '주민등록 번호',
                                initialValue: _details?.idNo,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '매장번호',
                                initialValue: _details?.storeContact,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '팩스번호',
                                initialValue: _details?.storeFax,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: CustomTextInput(
                                title: '매장주소',
                                initialValue: _details?.address,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: CustomTextInput(
                                title: '매장 상세주소',
                                initialValue: _details?.dtlAddress,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: CustomTextInput(
                                title: '이메일',
                                initialValue: _details?.email,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '접수일자',
                                initialValue: _details?.applyDate,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomTextInput(
                                title: '계약일자',
                                initialValue: _details?.contractDate,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: CustomTextInput(
                                title: '은행명',
                                initialValue: _details?.bankNm,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: CustomTextInput(
                                title: '계좌번호',
                                initialValue: _details?.bankNum,
                                readOnly: true,
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: CustomTextInput(
                                title: '상태코드명',
                                initialValue: _details?.statusNm,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const Gap(40),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            Container(
                              constraints: const BoxConstraints(minWidth: 100, minHeight: 35),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.blue),
                                  foregroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  _fetchApplicationImagesAndShow(_details?.bsRegNo);
                                },
                                child: const Text('사업자등록증'),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 100, minHeight: 35),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.orange),
                                  foregroundColor: Colors.orange,
                                ),
                                onPressed: () async {
                                  _fetchApplicationImagesAndShow(_details?.idCard);
                                },
                                child: const Text('신분증'),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 100, minHeight: 35),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.green),
                                  foregroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  _fetchApplicationImagesAndShow(_details?.bankBook);
                                },
                                child: const Text('통장사본'),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 100, minHeight: 35),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.purple),
                                  foregroundColor: Colors.purple,
                                ),
                                onPressed: () async {
                                  _fetchApplicationImagesAndShow(_details?.priorConsentForm);
                                },
                                child: const Text('사전승낙서'),
                              ),
                            ),
                          ],
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
      var result = await apiService.fetchRetailerDetails(
        context: context,
        retailerCode: widget.id,
      );
      _details = result;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _loading = false;
    setState(() {});
  }

  void _fetchApplicationImagesAndShow(String? fileName) async {
    if (fileName != null) {
      try {
        final APIService apiService = APIService();
        var result = await apiService.fetchRetailerImageByFileName(
          context: context,
          retailerCode: widget.id,
          fileName: fileName,
        );

        if (result != null && mounted) {
          showDialog(
            barrierColor: Colors.black,
            context: context,
            builder: (context) => ImageViewerContent(binaryImageList: [result]),
          );
        }
      } catch (e) {
        // print(e);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
