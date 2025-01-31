import 'package:befriend/views/widgets/befriend_widget.dart';
import 'package:flutter/material.dart';

import '../../models/objects/profile.dart';
import '../widgets/profile/header.dart';
import '../widgets/profile/pictures.dart';
import '../widgets/profile/state.dart';

class ProfilePage extends StatelessWidget {
  final Profile profile;

  const ProfilePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const BefriendTitle(),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    profile: profile,
                  ),
                  const SizedBox(height: 16),
                  ProfileState(user: profile.user),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pictures',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ProfilePictures(
              user: profile.user,
            ),
          ],
        ),
      ),
    );
  }
}
