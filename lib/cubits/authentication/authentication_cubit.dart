import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import 'package:skillsync/barrel_file.dart';
import 'package:skillsync/models/authentication_jwt_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<MasterState<AuthenticationState>> {
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  StreamSubscription<fb_auth.User?>? _authStateSubscription;

  AuthenticationCubit() : super(const Initial(AuthenticationState())) {
    monitorAuthState();
  }

  void monitorAuthState() {
    _authStateSubscription =
        _firebaseAuth.authStateChanges().listen((fb_auth.User? user) {
      if (user != null) {
        emit(Loaded(state.main.copyWith(isAuthenticated: true)));
      } else {
        emit(Loaded(
            state.main.copyWith(isAuthenticated: false, authToken: null)));
      }
    });
  }

  void reset() {
    emit(const Initial(AuthenticationState()));
  }

  Future<void> signInWithEmail(String email, String password) async {
    //   emit(Loading(state.main));
    //   try {
    //     await _firebaseAuth.signInWithEmailAndPassword(
    //       email: email.trim(),
    //       password: password.trim(),
    //     );
    //   } on fb_auth.FirebaseAuthException catch (e) {
    //     emit(Error(state.main,
    //         message: e.message ?? "An error occurred during sign in."));
    //   } catch (e) {
    //     emit(Error(state.main, message: "An unexpected error occurred."));
    //   }
    // }\
    emit(Loading(state.main));
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (userCredential.user != null) {
        emit(Loaded(state.main.copyWith(isAuthenticated: true)));
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      emit(Error(state.main,
          message: e.message ?? "An error occurred during sign in"));
    } catch (e) {
      emit(Error(state.main, message: "An unexpected error occurred."));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    emit(Loading(state.main));
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );
      //emit success
      emit(Loaded(state.main,
          message: "Password reset email sent! Check your inbox."));
    } on fb_auth.FirebaseAuthException catch (e) {
      emit(Error(state.main,
          message: e.message ??
              "Failed to send password reset email. Please try again later."));
    } catch (e) {
      emit(Error(state.main,
          message: "An unexpected error occurred. Please try again later."));
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String fullName) async {
    emit(Loading(state.main));
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(fullName);
        emit(Loaded(state.main.copyWith(isAuthenticated: true)));
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      emit(Error(state.main,
          message: e.message ?? "An error occurred during registration."));
    } catch (e) {
      emit(Error(state.main, message: "An unexpected error occurred."));
    }
  }

  Future<void> logout() async {
    emit(Loading(state.main));
    try {
      await _firebaseAuth.signOut();
      sl.authenticationCubit.reset();
      sl.generalCubit.reset();
      sl.screenControllerCubit.reset();
      sl.themeCubit.reset();
    } catch (e) {
      emit(Error(state.main, message: "An error occurred during logout."));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  // void authenticated(bool isAuthenticated) {
  //   emit(Loading(state.main));
  //   emit(Loaded(state.main.copyWith(isAuthenticated: isAuthenticated)));
  // }

  // void logout() {
  //   sl.authenticationCubit.reset();
  //   sl.generalCubit.reset();
  //   sl.screenControllerCubit.reset();
  //   sl.themeCubit.reset();
  // }
}
