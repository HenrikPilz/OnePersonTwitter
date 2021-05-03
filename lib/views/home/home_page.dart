import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:one_person_twitter/blocs/authentication/auth_bloc.dart';
import 'package:one_person_twitter/blocs/authentication/auth_event.dart';
import 'package:one_person_twitter/blocs/authentication/auth_state.dart';
import 'package:one_person_twitter/blocs/home/home_bloc.dart';
import 'package:one_person_twitter/blocs/home/home_event.dart';
import 'package:one_person_twitter/blocs/home/home_state.dart';
import 'package:one_person_twitter/helper/utils.dart';
import 'package:one_person_twitter/models/profile.dart';
import 'package:one_person_twitter/models/tweet.dart';
import 'package:one_person_twitter/routes/route_names.dart';
import 'package:one_person_twitter/helper/validator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tweetPageFormKey = GlobalKey<FormState>();
  final _tweetTextController = TextEditingController();
  Profile userProfile;
  List<Tweet> tweets = [];
  HomeBloc _homeBloc;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    fetchUserProfile();
    startTweetListener();
  }

  @override
  void dispose() {
    _homeBloc.close();
    _authenticationBloc.close();
    _tweetTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Tweets"),
        actions: <Widget>[
          TextButton(
            onPressed: signOut,
            child: Text(
              "Sign Out",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationStates>(
        listener: (context, state) {
          if (state is SignOutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              SigninRoute,
              (route) => false,
            );
          } else if (state is ProfileFetchSuccessState) {
            userProfile = state.profile;
          }
        },
        child: BlocConsumer<HomeBloc, HomeStates>(
          listener: (context, state) {
            if (state is FailureState) {
              final snackBar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is HomeLoadingState || state is TweetPostingState) {
              return Stack(
                children: [
                  tweetsView(),
                  SpinKitFadingCircle(
                    color: Colors.black,
                  )
                ],
              );
            } else if (state is FetchSuccessState) {
              tweets = state.tweets;
              tweets.sort((a, b) => b.time.compareTo(a.time));
              return tweetsView();
            }
            return tweetsView();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showTweetPage,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget tweetsView() {
    if (tweets.length == 0) {
      return Center(
        child: Text('No tweets!'),
      );
    }
    return SafeArea(
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(),
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 100),
          itemCount: tweets.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              tileColor: Colors.white,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                  imageUrl: tweets[index].postedBy.profileImagePath,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              title: Text(
                tweets[index].postedBy.name,
                style: Theme.of(context).textTheme.headline2,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tweets[index].message,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'on ${Utility().getFormattedDate(tweets[index].time)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              trailing: (tweets[index].postedBy.id == userProfile.id)
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () {
                            deleteTweet(id: tweets[index].id);
                          },
                          child: Icon(Icons.delete),
                        ),
                        InkWell(
                          onTap: () {
                            showTweetPage(tweet: tweets[index]);
                          },
                          child: Icon(Icons.edit),
                        ),
                      ],
                    )
                  : Container(
                      height: 1,
                      width: 1,
                    ),
            );
          }),
    );
  }

  showTweetPage({Tweet tweet}) {
    if (tweet != null) {
      _tweetTextController.text = tweet.message;
    } else {
      _tweetTextController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext _) {
        return Form(
          key: _tweetPageFormKey,
          child: Container(
            height: 300.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: _tweetTextController,
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(280),
                    ],
                    decoration: InputDecoration(
                      counterText: '280 chars allowed',
                      counterStyle: TextStyle(fontSize: 10),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    maxLines: 7,
                    minLines: 7,
                    validator: (value) => Validator().checkEmpty(value: value),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: ElevatedButton(
                          onPressed: () => onTweet(tweet: tweet),
                          child: Text('Tweet'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  signOut() {
    _authenticationBloc.add(
      SignOutEvent(),
    );
  }

  startTweetListener() {
    _homeBloc.add(
      StartTweetListener(),
    );
  }

  fetchUserProfile() {
    _authenticationBloc.add(
      GetUserProfile(),
    );
  }

  updateTweet({@required Tweet tweet}) {
    tweet.message = _tweetTextController.text;
    _homeBloc.add(
      UpdateTweet(
        tweet: tweet,
      ),
    );
  }

  postTweet() {
    if (!_tweetPageFormKey.currentState.validate()) {
      return;
    }
    _homeBloc.add(
      PostTweet(
          tweet: Tweet(
        message: _tweetTextController.text,
        time: DateTime.now(),
        postedBy: userProfile,
      )),
    );
  }

  deleteTweet({String id}) {
    _homeBloc.add(
      DeleteTweet(tweetId: id),
    );
  }

  onTweet({Tweet tweet}) {
    Navigator.of(context).pop();
    if (tweet != null) {
      updateTweet(tweet: tweet);
    } else {
      postTweet();
    }
  }
}
