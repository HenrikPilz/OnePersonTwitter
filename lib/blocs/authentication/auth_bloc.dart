import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_person_twitter/blocs/authentication/auth_event.dart';
import 'package:one_person_twitter/blocs/authentication/auth_state.dart';
import 'package:one_person_twitter/respository/auth_repository.dart';
import 'package:one_person_twitter/respository/user_repository.dart';
import 'package:one_person_twitter/service_locators/locator.dart';
import 'package:one_person_twitter/helper/custom_exception.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvents, AuthenticationStates> {
  AuthenticationBloc() : super(InitialState());

  var authRepository = locator<AuthRepository>();
  var userRepository = locator<UserRepository>();

  @override
  Stream<AuthenticationStates> mapEventToState(
      AuthenticationEvents event) async* {
    if (event is GetUserProfile) {
      var profile = userRepository.getUser();
      yield ProfileFetchSuccessState(profile: profile);
    } else if (event is SingInEvent) {
      yield LoadingState();
      try {
        bool success = await authRepository.singInWith(
            email: event.email, password: event.password);
        if (success) {
          yield SignInSuccessState();
        } else {
          yield AuthenticationFailureState(
              errorMessage: 'Cannot sign in with this credentials!');
        }
      } on OPTException catch (e) {
        yield AuthenticationFailureState(errorMessage: e.errorMessage);
      } catch (e) {
        yield AuthenticationFailureState(errorMessage: e.toString());
      }
    } else if (event is SingUpEvent) {
      yield LoadingState();
      try {
        bool success = await authRepository.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
          displayName: event.name,
          profileImage: event.profileImageFile,
        );
        if (success) {
          yield SignUpSuccessState();
        } else {
          yield AuthenticationFailureState(
              errorMessage: 'Cannot create an account right now!');
        }
      } on OPTException catch (e) {
        yield AuthenticationFailureState(errorMessage: e.errorMessage);
      } catch (e) {
        yield AuthenticationFailureState(errorMessage: e.toString());
      }
    } else if (event is SignOutEvent) {
      authRepository.signOut();
      yield SignOutSuccessState();
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
