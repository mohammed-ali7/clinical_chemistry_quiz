import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'question_model.dart';

part 'chapter_model.g.dart';

@HiveType(typeId: 1)
class Chapter extends HiveObject {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final List<Question> questions;

  Chapter({
    required this.title,
    required this.questions,
  });
}

/// Registers all Hive adapters with proper error handling
void registerHiveAdapters() {
  try {
    // Register Question adapter with typeId 0
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(QuestionAdapter());
    }
    
    // Register Chapter adapter with typeId 1
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChapterAdapter());
    }
    
    if (kDebugMode) {
      print('Hive adapters registered successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error registering Hive adapters: $e');
    }
    rethrow; // Re-throw to handle in the calling function
  }
}
