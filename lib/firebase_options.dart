// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Si tu veux conserver un message d'erreur pour les utilisateurs qui essaient de cibler le web.
      throw UnsupportedError(
        'Web configuration has been removed. You can add it again if needed.',
      );
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
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuOt0Mhxe7DWkGM4OdMIKy0SgS3sfwNkg',
    appId: '1:137928915151:android:171633bf92841959985fba',
    messagingSenderId: '137928915151',
    projectId: 'droneapplication-466a6',
    storageBucket: 'droneapplication-466a6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQ463fd5GLsvtqPgz6WhjmTlSS9OikEz8',
    appId: '1:137928915151:ios:7285d1bfe9c0fd07985fba',
    messagingSenderId: '137928915151',
    projectId: 'droneapplication-466a6',
    storageBucket: 'droneapplication-466a6.firebasestorage.app',
    iosBundleId: 'com.example.droneApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQ463fd5GLsvtqPgz6WhjmTlSS9OikEz8',
    appId: '1:137928915151:ios:7285d1bfe9c0fd07985fba',
    messagingSenderId: '137928915151',
    projectId: 'droneapplication-466a6',
    storageBucket: 'droneapplication-466a6.firebasestorage.app',
    iosBundleId: 'com.example.droneApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAjLnM2e2M8l4NK5NaV9ltwsknAMIEI_HE',
    appId: '1:137928915151:web:bad669191b8de970985fba',
    messagingSenderId: '137928915151',
    projectId: 'droneapplication-466a6',
    authDomain: 'droneapplication-466a6.firebaseapp.com',
    storageBucket: 'droneapplication-466a6.firebasestorage.app',
    measurementId: 'G-3E1Q45SZ4M',
  );
}
