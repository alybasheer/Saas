import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

class FirebaseConfig {
  static FirebaseApp? app;

  static Future<void> initializeApp() async {
    app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
