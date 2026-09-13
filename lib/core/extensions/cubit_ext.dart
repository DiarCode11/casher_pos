// lib/core/extensions/cubit_extension.dart
import 'package:flutter_bloc/flutter_bloc.dart';

extension SafeEmit<State> on Cubit<State> {
  void safeEmit(State newState) {
    if (!isClosed) emit(newState);
  }
}