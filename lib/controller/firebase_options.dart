import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwYRRWIutMbLiOEnICbNjJl5tEbkvs8H0',
    appId: '1:258602240024:web:649bea4c66ec964432db6d',
    messagingSenderId: '258602240024',
    projectId: 'steamgame-98e62',
    authDomain: 'steamgame-98e62.firebaseapp.com',
    storageBucket: 'steamgame-98e62.appspot.com',
    measurementId: 'G-NLXMZ12RT0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgo5Ovn9giN6BQUyxulkeZWx_BkQaXqIc',
    appId: '1:258602240024:android:1221d2d2dff9413932db6d',
    messagingSenderId: '258602240024',
    projectId: 'steamgame-98e62',
    storageBucket: 'steamgame-98e62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8TWkTP5z7ugdsbHv51sDGHROXAKStd8o',
    appId: '1:258602240024:ios:e96761970f6141dd32db6d',
    messagingSenderId: '258602240024',
    projectId: 'steamgame-98e62',
    storageBucket: 'steamgame-98e62.appspot.com',
    iosClientId: '258602240024-p985l8jpft3u2lfugqsbr31gbr4ajcoc.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8TWkTP5z7ugdsbHv51sDGHROXAKStd8o',
    appId: '1:258602240024:ios:28bf316fdb5cde2232db6d',
    messagingSenderId: '258602240024',
    projectId: 'steamgame-98e62',
    storageBucket: 'steamgame-98e62.appspot.com',
    iosClientId: '258602240024-llff66ceeaoa1nsd9d1aabvfa6ogdnob.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitled.RunnerTests',
  );
}
