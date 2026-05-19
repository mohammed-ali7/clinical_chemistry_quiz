import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clinical_chemistry_mcqs/models/question_model.dart';
import 'package:clinical_chemistry_mcqs/screens/quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Question> questions;
  final List<int> selectedAnswers;
  final String chapterTitle;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.selectedAnswers,
    required this.chapterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[800],
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Quiz Completed!',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      chapterTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.amber[400],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Score:',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF9FA8DA),
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$score / $totalQuestions',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Buttons - Responsive Layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // For larger screens, use a row layout
                        if (constraints.maxWidth > 600) {
                          return Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: _buildResponsiveButtons(context, isRow: true),
                          );
                        }
                        // For smaller screens, use column layout
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _buildResponsiveButtons(context, isRow: false),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAnswersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Answers',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Score: $score / $totalQuestions',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.indigo[700],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (ctx, index) {
                      final question = questions[index];
                      final userAnswerIndex = selectedAnswers[index];
                      final isCorrect = userAnswerIndex ==
                          question.correctAnswerIndex; // Use the correct answer index from the question

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isCorrect
                                ? Colors.green.shade300
                                : Colors.red.shade300,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isCorrect
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isCorrect
                                            ? Colors.green.shade800
                                            : Colors.red.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      question.questionText,
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...question.options.asMap().entries.map((option) {
                                final optionIndex = option.key;
                                final optionText = option.value;
                                bool isUserAnswer =
                                    optionIndex == userAnswerIndex;
                                bool isCorrectAnswer = optionIndex == question.correctAnswerIndex;

                                Color bgColor = Colors.grey[100]!;
                                Color textColor = Colors.black;
                                IconData? icon;

                                if (isUserAnswer && isCorrectAnswer) {
                                  bgColor = Colors.green.shade100;
                                  textColor = Colors.green.shade900;
                                  icon = Icons.check_circle;
                                } else if (isUserAnswer) {
                                  bgColor = Colors.red.shade100;
                                  textColor = Colors.red.shade900;
                                  icon = Icons.cancel;
                                } else if (isCorrectAnswer) {
                                  bgColor = Colors.green.shade50;
                                  textColor = Colors.green.shade800;
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isCorrectAnswer
                                          ? Colors.green.shade300
                                          : Colors.grey.shade300,
                                      width: isCorrectAnswer ? 1.5 : 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    title: Text(
                                      optionText,
                                      style: GoogleFonts.cairo(
                                        color: textColor,
                                        fontWeight:
                                            isUserAnswer || isCorrectAnswer
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                    trailing: icon != null
                                        ? Icon(
                                            icon,
                                            color: isCorrect
                                                ? Colors.green
                                                : Colors.red,
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResponsiveButtons(BuildContext context, {required bool isRow}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth > 600 
        ? (screenWidth * 0.25).clamp(200.0, 300.0) // Limit max width for very large screens
        : screenWidth * 0.9; // Use 90% of screen width on mobile

    const double buttonHeight = 50.0;
    final double spacing = isRow ? 10.0 : 12.0;

    return [
      // View Answers Button
      SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide.none,
            ),
          ),
          onPressed: () => _showAnswersDialog(context),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'View Answers',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      SizedBox(height: isRow ? 0 : spacing, width: isRow ? spacing : 0),

      // Restart Quiz Button
      SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.indigo,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide.none,
            ),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizScreen(
                        questions: questions,
                        chapterTitle: chapterTitle,
                      )),
              (route) => false,
            );
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Restart Quiz',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      SizedBox(height: isRow ? 0 : spacing, width: isRow ? spacing : 0),

      // Back to Tests Button
      SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[600],
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide.none,
            ),
          ),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Back to Tests',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
