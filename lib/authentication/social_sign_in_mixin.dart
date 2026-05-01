import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kasagardem/authentication/auth_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

mixin SocialSignInMixin {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  String? googleAuthToken = "";
  String? facebookAuthToken = "";
  String? appleAuthToken = "";
  AuthRepository authRepository = AuthRepository();
  AuthorizationCredentialAppleID? appleCredential;

  Future<UserCredential?> signInWithGoogle(
    VoidCallback registerGoogleToken,
  ) async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      googleAuthToken = googleAuth.idToken;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      debugPrint("googleAuth.idToken:::::::${googleAuth.idToken}");
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      registerGoogleToken();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {}
  }

  Future<void> signInWithApple(VoidCallback registerAppleToken) async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256(rawNonce);
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential!.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential!.identityToken,
        signInMethod: "apple.com",
      );
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      registerAppleToken();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<UserCredential?> signInWithFacebook(
    VoidCallback registerFacebookToken,
  ) async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256(rawNonce);
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginTracking: LoginTracking.enabled,
        nonce: nonce,
      );
      if (result.status == LoginStatus.success) {
        facebookAuthToken = result.accessToken!.tokenString;

        OAuthCredential credential;
        if (Platform.isIOS) {
          switch (result.accessToken!.type) {
            case AccessTokenType.classic:
              final token = result.accessToken as ClassicToken;
              credential = FacebookAuthProvider.credential(
                token.authenticationToken!,
              );
              facebookAuthToken = token.authenticationToken!;
              break;
            case AccessTokenType.limited:
              final token = result.accessToken as LimitedToken;
              credential = OAuthCredential(
                providerId: 'facebook.com',
                signInMethod: 'oauth',
                idToken: token.tokenString,
                rawNonce: rawNonce,
              );
              facebookAuthToken = token.tokenString;
              break;
          }
        } else {
          facebookAuthToken = result.accessToken!.tokenString;
          credential = FacebookAuthProvider.credential(
            result.accessToken!.tokenString,
          );
        }
        //  credential = FacebookAuthProvider.credential(facebookAuthToken!);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        registerFacebookToken();
        return userCredential;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  String _generateNonce([int length = 32]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  String _sha256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
