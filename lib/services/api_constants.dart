class ApiConstants{


  static const String baseUrl = "https://love-mamun.sarv.live/api/v1";
  static const String imageBaseUrl = "https://love-mamun.sarv.live/upload/";
  static const String socketBaseUrl = "https://love-mamun.sarv.live";






















  static const String signInEndPoint = "/auth/login";
  static  String getReminder(String? page) => "/reminder?limit=10&page=${page??"1"}";



}