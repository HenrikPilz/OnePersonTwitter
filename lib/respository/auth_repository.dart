import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:one_person_twitter/helper/custom_exception.dart';

class AuthRepository {
  Future<bool> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
    @required File profileImage,
    @required String displayName,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        updateProfileImageAndName(
          profileImage: profileImage,
          displayName: displayName,
        );
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw OPTException(
            errorMessage: 'The account already exists for this email.');
      } else {
        throw OPTException(errorMessage: e.message);
      }
    } catch (e) {
      print(e);
      throw OPTException(errorMessage: e);
    }
  }

  Future<bool> singInWith({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw OPTException(
            errorMessage: 'User doesnot exist! Please create an account.');
      } else {
        throw OPTException(errorMessage: e.message);
      }
    } catch (e) {
      print(e);
      throw OPTException(errorMessage: e);
    }
  }

  updateProfileImageAndName({
    @required File profileImage,
    @required String displayName,
  }) async {
    FirebaseAuth.instance.currentUser.updateProfile(displayName: displayName);
    final String userId = FirebaseAuth.instance.currentUser.uid;
    Reference reference = FirebaseStorage.instance.ref().child("$userId");
    UploadTask task = reference.putFile(profileImage);
    task.then((res) async {
      String photoUrl = await res.ref.getDownloadURL();
      FirebaseAuth.instance.currentUser.updateProfile(photoURL: photoUrl);
    });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
