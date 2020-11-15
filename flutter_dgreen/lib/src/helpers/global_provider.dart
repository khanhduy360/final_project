import 'package:flutter/cupertino.dart';
import 'package:flutter_dgreen/src/model/user.dart';

class GlobalProvider extends ChangeNotifier {
  UserApp _userInfo;

  bool isLoading = false;
  String currentAddress = '';
  bool isLogout = false;
  String searchAddress = '';

  UserApp get userInfo => _userInfo;
  onChangeUserProfileProvider({@required UserApp newValue}) {
    _userInfo = newValue;
    notifyListeners();
  }

  updateSearchLocation(newLocation) {
    searchAddress = newLocation.description;
    notifyListeners();
  }

  updateLoadingStatus() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
