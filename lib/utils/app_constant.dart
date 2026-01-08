
class AppConstants{

  ///=======================Prefs Helper data===============================>
  static String bearerToken = 'token';
  static String email = 'email';
   static String userId = 'userId';
  static String name = 'name';
  static String isLogged = 'isLogged';
  static String image = 'image';
  static String inviteCode = 'inviteCode';
  static String partnerName = 'partnerName';


  static RegExp emailValidate = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{8,}$');
    return regex.hasMatch(value);
  }



}
enum Status { loading, completed, error, internetError }