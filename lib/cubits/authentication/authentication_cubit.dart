import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import 'package:skillsync/barrel_file.dart';
import 'package:skillsync/models/authentication_jwt_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

//helper method - error handling, nicer error messages
  String _mapAuthException(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "The email address format is not correct, please ensure the full email address is entered!";
      case 'user-disabled':
        return "This account has been disabled. Please contact support@skillsync.co.za";
      case 'user-not-found':
        return "We couldn't find an account with this email. Register for an account now!";
      case 'wrong-password':
      case 'invalid-credential':
        return "The password you have entered is incorrect, please double-check and try again, or request a password reset";
      case 'email-already-in-use':
        return "An account is already registered with this email. Try logging in instead!";
      case 'weak-password':
        return "Please choose a stronger password (min 8 characters, min 1 special character, min 1 number)";
      case 'network-request-failed':
        return "A connection error occurred. Check your internet and try again!";
      default:
        return e.message ?? "An unexpected error occurred. Please try again.";
    }
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
      emit(Error(state.main, message: _mapAuthException(e)));
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
      emit(Error(state.main, message: _mapAuthException(e)));
      //     message: e.message ??
      // emit(Error(state.main,
      //     message: e.message ??
      //         "Failed to send password reset email. Please try again later."));
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
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;

      if (user == null) {
        throw Exception("User creation failed");
      }

      // Firebase Auth display name
      await user.updateDisplayName(fullName);

      // CREATE Firestore user profile
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': fullName,
        'email': email.trim(),
        'xp': 0,
        //'streak' : 1,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(Loaded(state.main.copyWith(isAuthenticated: true)));
    } on fb_auth.FirebaseAuthException catch (e) {
      // emit(Error(state.main,
      //     message: e.message ?? "An error occurred during registration."));
      emit(Error(state.main, message: _mapAuthException(e)));
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
