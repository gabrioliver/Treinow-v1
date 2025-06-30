import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('Configure o iOS manualmente.');
      case TargetPlatform.macOS:
        throw UnsupportedError('Configure o macOS manualmente.');
      case TargetPlatform.windows:
        return android; // usa a mesma config do Android
      case TargetPlatform.linux:
        throw UnsupportedError('Firebase não configurado para Linux.');
      default:
        throw UnsupportedError('Plataforma não suportada.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBBws3_N1EuQ9M7EtHFvmnh8eRNWuSLAqw',
    appId: '1:441212964869:web:COLE_AQUI_SEU_ID_WEB',
    messagingSenderId: '441212964869',
    projectId: 'treinow-dfe44',
    authDomain: 'treinow-dfe44.firebaseapp.com',
    storageBucket: 'treinow-dfe44.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBws3_N1EuQ9M7EtHFvmnh8eRNWuSLAqw',
    appId: '1:441212964869:android:d77c3a592a92a0159ecc6c',
    messagingSenderId: '441212964869',
    projectId: 'treinow-dfe44',
    storageBucket: 'treinow-dfe44.appspot.com',
  );
}
