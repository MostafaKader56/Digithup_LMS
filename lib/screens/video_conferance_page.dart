import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'dart:math';

import '../constants.dart';

class VideoConferancePage extends StatelessWidget {
  VideoConferancePage({super.key});
  static const routeName = 'VideoConferancePage';

  final String userId = Random().nextInt(900000 + 100000).toString();
/*
ZEGO_APP_ID=1839004996
ZEGO_APP_SIGN=32e9f855c9c970fe400414a01eeb0b365483290b34b8e720176c4cfd589ef79e
*/

  @override
  Widget build(BuildContext context) {
    // print('conferanceID: $myMeetingId');
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID:
            appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: 'user $userId',
        conferenceID: myMeetingId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}
