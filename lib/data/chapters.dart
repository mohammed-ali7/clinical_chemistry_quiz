import 'package:clinical_chemistry_mcqs/models/chapter_model.dart';
import 'package:clinical_chemistry_mcqs/data/questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_2_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_3_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_4_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_5_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_6_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_7_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_8_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_9_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_10_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_11_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_12_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_13_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_14_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_15_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_16_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_17_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_18_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_19_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_20_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_21_questions.dart';
import 'package:clinical_chemistry_mcqs/data/chapter_22_questions.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

final List<Chapter> defaultChapters = [
  Chapter(title: 'Chapter 1: Biochemistry and cell biology', questions: chapter1Questions),
  Chapter(title: 'Chapter 2: Biochemical investigations in clinical medicine', questions: chapter2Questions),
  Chapter(title: 'Chapter 3: Water, sodium and potassium', questions: chapter3Questions),
  Chapter(title: 'Chapter 4: Hydrogen ion homoeostasis and blood gases', questions: chapter4Questions),
  Chapter(title: 'Chapter 5: The kidneys', questions: chapter5Questions),
  Chapter(title: 'Chapter 6: The liver', questions: chapter6Questions),
  Chapter(title: 'Chapter 7: The gastrointestinal tract', questions: chapter7Questions),
  Chapter(title: 'Chapter 8: Clinical nutrition', questions: chapter8Questions),
  Chapter(title: 'Chapter 9: The hypothalamus and the pituitary gland', questions: chapter9Questions),
  Chapter(title: 'Chapter 10: The adrenal glands', questions: chapter10Questions),
  Chapter(title: 'Chapter 11: The thyroid gland', questions: chapter11Questions),
  Chapter(title: 'Chapter 12: The gonads', questions: chapter12Questions),
  Chapter(title: 'Chapter 13: Carbohydrate metabolism disorders', questions: chapter13Questions),
  Chapter(title: 'Chapter 14: Calcium, phosphate & magnesium', questions: chapter14Questions),
  Chapter(title: 'Chapter 15: Bones and joints', questions: chapter15Questions),
  Chapter(title: 'Chapter 16: Plasma proteins & enzymes', questions: chapter16Questions),
  Chapter(title: 'Chapter 17: Lipids & cardiovascular disease', questions: chapter17Questions),
  Chapter(title: 'Chapter 18: Muscles, nerves & psychiatry', questions: chapter18Questions),
  Chapter(title: 'Chapter 19: Inherited metabolic diseases', questions: chapter19Questions),
  Chapter(title: 'Chapter 20: Cancer metabolism', questions: chapter20Questions),
  Chapter(title: 'Chapter 21: Drug monitoring & toxicology', questions: chapter21Questions),
  Chapter(title: 'Chapter 22: Pediatric clinical chemistry', questions: chapter22Questions),
];

Future<List<Chapter>> getChapters() async {
  try {
    if (!Hive.isBoxOpen('chapters')) {
      await Hive.openBox<Chapter>('chapters');
    }
    
    final box = Hive.box<Chapter>('chapters');
    
    // If we have saved chapters, return them
    if (box.isNotEmpty) {
      return box.values.toList();
    }
    
    // Otherwise, save default chapters and return them
    await box.addAll(defaultChapters);
    return List<Chapter>.from(defaultChapters);
  } catch (e) {
    if (kDebugMode) {
      print('Error in getChapters: $e');
    }
    // In case of any error, return default chapters
    return List<Chapter>.from(defaultChapters);
  }
}

Future<void> saveChapters(List<Chapter> chapters) async {
  try {
    if (!Hive.isBoxOpen('chapters')) {
      await Hive.openBox<Chapter>('chapters');
    }
    
    final box = Hive.box<Chapter>('chapters');
    await box.clear();
    await box.addAll(chapters);
  } catch (e) {
    if (kDebugMode) {
      print('Error in saveChapters: $e');
    }
    rethrow; // Re-throw to let the caller handle the error
  }
}
