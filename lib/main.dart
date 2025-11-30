import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'controllers/auth_controller.dart';
import 'controllers/couple_controller.dart';
import 'controllers/reminder_controller.dart';
import 'controllers/memory_controller.dart';
import 'controllers/mood_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Inject GetX controllers
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(CoupleController());
  Get.put(ReminderController());
  Get.put(MemoryController());
  Get.put(MoodController());
  runApp(const MyLoveReminderApp());
}

class MyLoveReminderApp extends StatelessWidget {
  const MyLoveReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // Example: iPhone 14 Pro design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'My Love Reminder',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.interTextTheme(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            scaffoldBackgroundColor: AppColors.background,
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:testapp/views/screens/auth/login_screen.dart';


// void main() {
//   runApp(const MyApp());
// }



// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(393, 852),
//       minTextAdapt: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           title: 'Droke',
//           debugShowCheckedModeBanner: false,
//           initialRoute: AppRoutes.splashScreen,
//           getPages: AppRoutes.routes,
//           theme: light(),
//           themeMode: ThemeMode.light,
//           home: child,
//         );
//       },
//       child: const SplashScreen(),
//     );
//   }
// }