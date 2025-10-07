import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_state.dart';

class UserCubit extends Cubit<UserState?> {
  UserCubit() : super(null);  // Initially no user logged in

  void setUserDetails({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) {
    emit(UserState(uid: uid, name: name, email: email, phone: phone));
  }

  void clearUser() {
    emit(null);
  }
}
