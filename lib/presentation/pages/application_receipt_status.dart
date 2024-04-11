import 'package:admin_simpass/presentation/components/header.dart';
import 'package:flutter/material.dart';

class ApplicationReceiptStatusPage extends StatefulWidget {
  const ApplicationReceiptStatusPage({super.key});

  @override
  State<ApplicationReceiptStatusPage> createState() => RApplicationReceiptStatusPageState();
}

class RApplicationReceiptStatusPageState extends State<ApplicationReceiptStatusPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(title: "신청서 접수현황"),
        Text('profile '),
      ],
    );
  }
}
