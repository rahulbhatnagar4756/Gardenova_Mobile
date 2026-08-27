import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthSession {
  SocialAuthSession._();

  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.disconnect();
    } catch (e) {
      debugPrint('Google disconnect failed: $e');
      try {
        await GoogleSignIn.instance.signOut();
      } catch (signOutError) {
        debugPrint('Google signOut failed: $signOutError');
      }
    }

    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint('Facebook logOut failed: $e');
    }

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Firebase signOut failed: $e');
    }
  }
}
