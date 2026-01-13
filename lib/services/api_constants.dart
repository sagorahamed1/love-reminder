class ApiConstants{


  // static const String baseUrl = "https://love-mamun.sarv.live/api/v1";
  // static const String imageBaseUrl = "https://love-mamun.sarv.live/upload/";
  // static const String socketBaseUrl = "https://love-mamun.sarv.live";


  static const String baseUrl = "https://6c0hk6c2-8089.inc1.devtunnels.ms/api/v1";
  static const String imageBaseUrl = "https://6c0hk6c2-8089.inc1.devtunnels.ms/uploads/";
  static const String socketBaseUrl = "https://6c0hk6c2-8089.inc1.devtunnels.ms";






















  static const String signInEndPoint = "/auth/login";
  static const String mood = "/mood";
  static String getReminder(String? page) => "/reminder?limit=5&page=${page ?? "1"}";




}