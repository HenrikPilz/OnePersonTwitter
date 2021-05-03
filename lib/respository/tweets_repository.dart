import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_person_twitter/models/profile.dart';
import 'package:one_person_twitter/models/tweet.dart';
import 'package:one_person_twitter/helper/custom_exception.dart';

class TweetsRepository {
  Future<bool> postTweet(Tweet tweet) async {
    try {
      var value = await FirebaseFirestore.instance
          .collection('all_tweets')
          .add(tweet.toJson());
      print(value);
      if (value.id != null) {
        return true;
      }
      return false;
    } catch (e) {
      throw OPTException(errorMessage: e.toString());
    }
  }

  deleteTweet({String tweetId}) async {
    FirebaseFirestore.instance.collection('all_tweets').doc(tweetId).delete();
  }

  updateTweet({Tweet tweet}) async {
    FirebaseFirestore.instance
        .collection('all_tweets')
        .doc(tweet.id)
        .update(tweet.toJson());
  }

  listenForFirestoreUpdates(StreamController controller) {
    FirebaseFirestore.instance
        .collection('all_tweets')
        .snapshots()
        .listen((event) => controller.add(true));
  }

  Future<List<Tweet>> fetchAllTweets() async {
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('all_tweets').get();
      return result.docs
          .map(
            (e) => Tweet(
              message: e['message'],
              time: e['time'].toDate(),
              id: e.id,
              postedBy: Profile(
                  id: e['postedBy']['id'],
                  name: e['postedBy']['name'],
                  profileImagePath: e['postedBy']['profileImagePath']),
            ),
          )
          .toList();
    } catch (e) {
      throw OPTException(errorMessage: e.toString());
    }
  }
}
