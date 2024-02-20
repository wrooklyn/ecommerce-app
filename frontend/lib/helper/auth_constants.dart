import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

const GOOGLE_ISSUER = 'https://accounts.google.com';
final String GOOGLE_CLIENT_ID_IOS = FlutterConfig.get('GOOGLE_AUTH_IOS_CLIENT_ID');
final String GOOGLE_REDIRECT_URI_IOS = 'com.googleusercontent.apps.$GOOGLE_CLIENT_ID_IOS:/http://localhost:3003/auth/google';
final String GOOGLE_CLIENT_ID_ANDROID =  FlutterConfig.get('GOOGLE_AUTH_ANDROID_CLIENT_ID');
final String GOOGLE_REDIRECT_URI_ANDROID = 'com.googleusercontent.apps.$GOOGLE_CLIENT_ID_ANDROID:/http://localhost:3003/auth/google';

String clientID() {
  if(Platform.isAndroid) {
    return GOOGLE_CLIENT_ID_ANDROID;
  } else if (Platform.isIOS) {
    return GOOGLE_CLIENT_ID_IOS;
  }
  return '';
}

String redirectUrl() {
  if(Platform.isAndroid) {
    return GOOGLE_REDIRECT_URI_ANDROID;
  } else if (Platform.isIOS) {
    return GOOGLE_REDIRECT_URI_IOS;
  }
  return '';
}