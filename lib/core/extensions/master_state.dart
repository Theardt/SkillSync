import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:skillsync/core/dependency_injection.dart';
import 'package:skillsync/models/error_model.dart';

enum MasterActions {
  doNothing,
  goToHome,
  shouldPop,
}

class GlobalVars extends Equatable {
  const GlobalVars();

  @override
  List<Object?> get props => [];
}

abstract class MasterState<T extends GlobalVars> extends Equatable {
  final T main;
  final String message;
  final MasterActions? action;

  const MasterState(this.main, {this.message = "", this.action});

  bool get showSnackBar => message.isNotEmpty && message != 'Success';

  @override
  List<Object?> get props => [main, message, action];
}

class Initial<T extends GlobalVars> extends MasterState<T> {
  const Initial(super.main);
}

class Loading<T extends GlobalVars> extends MasterState<T> {
  const Loading(super.main, {super.action, super.message});
}

class Loaded<T extends GlobalVars> extends MasterState<T> {
  const Loaded(super.main, {super.action, super.message});
}

class Message<T extends GlobalVars> extends MasterState<T> {
  const Message(super.main, {super.action, super.message});
}

class Error<T extends GlobalVars> extends MasterState<T> {
  final String? stackTrace;
  final bool addLog;

  Error(super.main, {this.stackTrace, this.addLog = true, super.action, super.message}) {
    if (kDebugMode) {
      log('ERROR: $message');
      log('ERROR: $stackTrace');
    }
    ErrorModel error = ErrorModel(error: message, stackTrace: stackTrace.toString());
    if (addLog && !kDebugMode) sl.generalCubit.log(error);
  }
}
