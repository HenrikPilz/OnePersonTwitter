import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_person_twitter/models/profile.dart';

class UserRepository {
  Profile getUser() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return Profile(
      id: firebaseUser.uid,
      name: firebaseUser.displayName,
      profileImagePath: firebaseUser.photoURL,
    );
  }
}
