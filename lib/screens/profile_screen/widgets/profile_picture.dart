import 'package:flutter/material.dart';

import '../../../blocs/profile/profile_bloc.dart';

Center profilePicture(ProfileLoaded state) {
  return Center(
    child: CircleAvatar(
      radius: 65,
      backgroundColor: Colors.teal[900],
      child: CircleAvatar(
        radius: 60,
        backgroundImage: state.user.photoUrl.isNotEmpty
            ? NetworkImage(state.user.photoUrl)
            : const AssetImage('assets/default_profile.png') as ImageProvider,
      ),
    ),
  );
}
