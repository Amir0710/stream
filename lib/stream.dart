import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';


class Stream extends StatelessWidget {
  final bool isHost;
  final String filePath;
  final String username;
  final String userID;

  const Stream(
      {super.key,
      required this.username,
      required this.userID,
      required this.isHost,
      required this.filePath});


  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 62117945,
        appSign:
            '7f0ca34cca476e3ffe96bdc2e4db0e47ca57d461c9c9d042eb7365d76f3614ce',
        userID: userID,
        userName: username,
        liveID: 'Rabbaniamir30@gmail.com',
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
          ..avatarBuilder = (BuildContext context, Size size,
              ZegoUIKitUser? user, Map extraInfo) {
            return user != null
                ? ClipOval(
                    child: filePath.contains('assets')
                        ? Image.asset(
                            filePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(filePath),
                            fit: BoxFit.cover,
                          ),
                  )
                : const SizedBox();
          },
      ),
    );
  }
}
