import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

// STREETWEAR APP COLOR PALETTE
const Color kDarkGray = Color(0xFF2A3440);
const Color kMediumGray = Color(0xFFA0A6AD);
const Color kLightGray = Color(0xFFDCE0E3);
const Color kWhite = Color(0xFFF8FAFC);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize CartProvider before runApp
  final cartProvider = CartProvider();
  cartProvider.initializeAuthListener();

  runApp(
    ChangeNotifierProvider.value(
      value: cartProvider,
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streetwear Shop',

      theme: ThemeData(
        useMaterial3: true,

        // COLOR SCHEME
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: kDarkGray,
          onPrimary: kWhite,
          secondary: kMediumGray,
          onSecondary: kWhite,
          background: kWhite,
          onBackground: kDarkGray,
          surface: kLightGray,
          onSurface: kDarkGray,
          error: Colors.red,
          onError: kWhite,
        ),

        // FONT
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: kDarkGray,
            displayColor: kDarkGray,
          ),
        ),

        // SCAFFOLD BACKGROUND
        scaffoldBackgroundColor: kWhite,

        // APP BAR
        appBarTheme: const AppBarTheme(
          backgroundColor: kDarkGray,
          foregroundColor: kWhite,
          elevation: 0,
          centerTitle: true,
        ),

        // BUTTONS
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkGray,
            foregroundColor: kWhite,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // TEXT FIELDS
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kMediumGray),
          ),
          labelStyle: TextStyle(color: kMediumGray),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kDarkGray, width: 2.0),
          ),
        ),

        // CARDS
        cardTheme: CardThemeData(
          elevation: 2,
          color: kLightGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
        ),

        // ICONS
        iconTheme: const IconThemeData(
          color: kDarkGray,
        ),
      ),

      home: const AuthWrapper(),
    );
  }
}
