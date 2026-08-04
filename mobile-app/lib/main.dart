import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';
import 'presentation/auth/auth_screen.dart';
import 'presentation/auth/providers/auth_provider.dart';

void main() {
  runApp(const OSECApp());
}

/// Root of the OSEC application.
///
/// Racine de l'application OSEC.
///
/// Registers app-wide providers (currently [AuthProvider]) above [MaterialApp]
/// so any screen can read authentication state.
class OSECApp extends StatelessWidget {
  const OSECApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appFullName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
        ],
        // NOTE: Temporarily launching straight into the auth flow to make it
        // easy to test. Restore [OnboardingScreen] (→ AuthScreen) once the
        // authentication work is validated.
        //
        // NOTE : lancement direct sur l'authentification pour faciliter les
        // tests. Restaurer [OnboardingScreen] une fois l'auth validée.
        home: const AuthScreen(),
      ),
    );
  }
}
