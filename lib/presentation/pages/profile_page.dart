import 'package:admin_simpass/presentation/components/header.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(title: "나의 정보"),
        Text('profile '),
      ],
    );
  }
}
