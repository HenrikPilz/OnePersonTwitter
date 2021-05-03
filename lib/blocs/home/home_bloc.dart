import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_person_twitter/blocs/home/home_event.dart';
import 'package:one_person_twitter/blocs/home/home_state.dart';
import 'package:one_person_twitter/respository/tweets_repository.dart';
import 'package:one_person_twitter/service_locators/locator.dart';
import 'package:one_person_twitter/helper/custom_exception.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  HomeBloc() : super(InitialState());

  var tweetFirestoreRepository = locator<TweetsRepository>();
  
  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async* {
    if (event is StartTweetListener) {
      var controller = locator<StreamController<bool>>();
      controller.stream.listen((event) => add(FetchAllTweets()));
      tweetFirestoreRepository.listenForFirestoreUpdates(controller);
    } else if (event is PostTweet) {
      yield TweetPostingState();
      try {
        bool success = await tweetFirestoreRepository.postTweet(event.tweet);
        if (success) {
          yield PostSuccessState();
        } else {
          yield FailureState(
              errorMessage: 'Cannot tweet now. please try later');
        }
      } on OPTException catch (e) {
        yield FailureState(errorMessage: e.errorMessage);
      } catch (e) {
        yield FailureState(errorMessage: e.toString());
      }
    } else if (event is FetchAllTweets) {
      yield HomeLoadingState();
      try {
        var tweets = await tweetFirestoreRepository.fetchAllTweets();
        yield FetchSuccessState(tweets: tweets);
      } on OPTException catch (e) {
        yield FailureState(errorMessage: e.errorMessage);
      } catch (e) {
        yield FailureState(errorMessage: e.toString());
      }
    } else if (event is DeleteTweet) {
      tweetFirestoreRepository.deleteTweet(tweetId: event.tweetId);
    } else if (event is UpdateTweet) {
      tweetFirestoreRepository.updateTweet(tweet: event.tweet);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
