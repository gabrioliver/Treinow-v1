// File generated manually
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Configurações padrão para o Firebase
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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'FirebaseOptions não configurado para Linux. Execute o FlutterFire CLI novamente para gerar.',
        );
      default:
        throw UnsupportedError(
          'FirebaseOptions não suportado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8ALOtEb-HLpi13au_9ATqULRGmnJ_s-Q',
    appId: '1:278717481403:web:ac86f3940998091358449e',
    messagingSenderId: '278717481403',
    projectId: 'appnupe',
    authDomain: 'appnupe.firebaseapp.com',
    storageBucket: 'appnupe.appspot.com',
    measurementId: 'G-XXXXXXXXXX', // Altere se tiver medição ativa
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6xhUpRUzRZgI9V4eF5Qe1wkG0So7hy5k',
    appId: '1:278717481403:android:a8c024191026181b58449e',
    messagingSenderId: '278717481403',
    projectId: 'appnupe',
    storageBucket: 'appnupe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWbf-V-2RV4_O4htCdMS0jEk-8MxRg0pg',
    appId: '1:278717481403:ios:f25ef6b1a3a7015058449e',
    messagingSenderId: '278717481403',
    projectId: 'appnupe',
    storageBucket: 'appnupe.appspot.com',
    iosBundleId: 'com.example.appNupe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBWbf-V-2RV4_O4htCdMS0jEk-8MxRg0pg',
    appId: '1:278717481403:ios:f25ef6b1a3a7015058449e',
    messagingSenderId: '278717481403',
    projectId: 'appnupe',
    storageBucket: 'appnupe.appspot.com',
    iosBundleId: 'com.example.appNupe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD8ALOtEb-HLpi13au_9ATqULRGmnJ_s-Q',
    appId: '1:278717481403:web:d413e3577407822c58449e',
    messagingSenderId: '278717481403',
    projectId: 'appnupe',
    authDomain: 'appnupe.firebaseapp.com',
    storageBucket: 'appnupe.appspot.com',
    measurementId: 'G-XXXXXXXXXX', // Altere se necessário
  );
}
