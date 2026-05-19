import 'package:hive/hive.dart';

part 'question_model.g.dart';

// This file is the model for questions in the quiz app.
// It defines the Question class that represents a single quiz question
// with its text, options, and the index of the correct answer.

@HiveType(typeId: 0)
class Question extends HiveObject {
  @HiveField(0)
  final String questionText;
  
  @HiveField(1)
  final List<String> options;
  
  @HiveField(2)
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}
