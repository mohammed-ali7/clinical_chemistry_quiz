import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'data/chapters.dart' show getChapters;
import 'models/chapter_model.dart' show Chapter, registerHiveAdapters;

void main() async {
  // Disable debug print in all modes
  debugPrint = (String? message, {int? wrapWidth}) {};
  
  // Disable debug banner and other debug indicators in debug mode
  if (kDebugMode) {
    // These settings will only apply in debug mode
    // No need for debugPaintSizeEnabled as it's not available in stable Flutter
  }
  
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Hive
    if (kIsWeb) {
      // For web
      await Hive.initFlutter();
    } else {
      // For mobile/desktop
      final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }
    
    // Register all adapters
    registerHiveAdapters();
    
    // Open Hive boxes
    await Hive.openBox('app_preferences');
    
    // Initialize chapters box
    if (!Hive.isBoxOpen('chapters')) {
      await Hive.openBox<Chapter>('chapters');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Hive: $e');
    }
    // In case of error, clear Hive and retry
    await Hive.close();
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    registerHiveAdapters();
    await Hive.openBox('app_preferences');
    await Hive.openBox<Chapter>('chapters');
  }
  
  // Load chapters asynchronously
  List<Chapter> chapters;
  try {
    chapters = await getChapters();
  } catch (e) {
    if (kDebugMode) {
      print('Error loading chapters: $e');
    }
    // Return empty list if there's an error
    chapters = [];
  }
  
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => chapters),
        // يمكن إضافة المزيد من الـ providers هنا
      ],
      child: Builder(
        builder: (context) {
          // Force disable all debug indicators
          debugPrint = (String? message, {int? wrapWidth}) {};
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            showPerformanceOverlay: false,
            checkerboardRasterCacheImages: false,
            checkerboardOffscreenLayers: false,
            showSemanticsDebugger: false,
            home: const HomeScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: MediaQuery.textScalerOf(context).clamp(
                    minScaleFactor: 0.8,
                    maxScaleFactor: 1.2,
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Close Hive boxes when the app is closed
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // تعطيل جميع إعدادات التصحيح
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      checkerboardRasterCacheImages: false,
      checkerboardOffscreenLayers: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      title: 'Clinical Chemistry MCQs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        // تحسين أداء الرسوم المتحركة
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
