import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNCtw0FC0qC0j5bRg_o336xrdWEbRHz78',
    appId: '1:384503029364:android:1471d82a8f50c3ed2fbb21',
    messagingSenderId: 'MASUKKAN_SENDER_ID_DI_SINI',
    projectId: 'app-wahidiyah',
    storageBucket: 'app-wahidiyah.appspot.com',
  );
}
