import 'package:flutter/material.dart';

import '/profile/widget/profile_app_bar_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBarWidget(),
      body: Center(child: Text('Profile Screen')),
    );
  }
}
