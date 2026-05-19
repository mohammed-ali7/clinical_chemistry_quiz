import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clinical_chemistry_mcqs/models/question_model.dart';
import 'package:clinical_chemistry_mcqs/screens/result_screen.dart';

// Cache Google Fonts to improve performance
final _questionTextStyle = GoogleFonts.poppins(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.3,
);

final _optionTextStyle = GoogleFonts.poppins(
  color: Colors.black87,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

final _buttonTextStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.3,
);

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String chapterTitle;

  const QuizScreen({
    super.key, 
    required this.questions,
    required this.chapterTitle,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _score = 0;
  final Map<int, int> _userAnswers = {}; // To store user's answers

  void _answerQuestion(int selectedIndex) {
    // Allow answering only once
    if (_userAnswers.containsKey(_questionIndex)) return;

    setState(() {
      _userAnswers[_questionIndex] = selectedIndex;
      if (selectedIndex == widget.questions[_questionIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_questionIndex < widget.questions.length - 1) {
      setState(() {
        _questionIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    // Create a list of all answers, defaulting to -1 for unanswered questions
    final List<int> allAnswers = List.generate(
      widget.questions.length,
      (index) => _userAnswers[index] ?? -1,
      growable: false,
    );
    
    // Use a fade transition for a smoother navigation
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultScreen(
          score: _score,
          totalQuestions: widget.questions.length,
          questions: widget.questions,
          selectedAnswers: allAnswers,
          chapterTitle: widget.chapterTitle,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _previousQuestion() {
    if (_questionIndex > 0) {
      setState(() {
        _questionIndex--;
      });
    }
  }

  // Helper methods for better performance
  Widget _buildOptionButton(int index) {
    final isSelected = _userAnswers[_questionIndex] == index;
    final isCorrect = index == widget.questions[_questionIndex].correctAnswerIndex;
    final isAnswered = _userAnswers.containsKey(_questionIndex);
    
    Color getButtonColor() {
      if (!isAnswered) {
        return isSelected ? Colors.blue[100]! : Colors.white;
      }
      if (isCorrect) return Colors.green;
      if (isSelected) return Colors.red;
      return Colors.white.withOpacity(0.2);
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _answerQuestion(index),
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: getButtonColor(),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: isAnswered && isCorrect
                    ? Colors.green
                    : isAnswered && isSelected
                        ? Colors.red
                        : Colors.grey[300]!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.questions[_questionIndex].options[index],
              style: _optionTextStyle.copyWith(
                color: isAnswered && (isCorrect || isSelected)
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({required VoidCallback? onPressed, required String text, bool isPrimary = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                colors: [Colors.amber[700]!, Colors.orange[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: Colors.amber[700]!.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.transparent : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.indigo[900],
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide.none,
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: _buttonTextStyle.copyWith(
            color: isPrimary ? Colors.white : Colors.indigo[900],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E21), Color(0xFF1D1E33)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with back button only
              AppBar(
                title: const Text(''),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Chapter Title
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                          child: Text(
                            widget.chapterTitle,
                            style: _questionTextStyle.copyWith(
                              fontSize: 16,
                              color: Colors.amber[400],
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Question Counter
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
                          child: Text(
                            'Question ${_questionIndex + 1} of ${widget.questions.length}',
                            style: _questionTextStyle.copyWith(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // Question Text
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.indigo[900]!.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: Colors.indigo[700]!, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.questions[_questionIndex].questionText,
                            style: _questionTextStyle.copyWith(
                              fontSize: 18,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Options
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.questions[_questionIndex].options.length,
                          itemExtent: 70,
                          itemBuilder: (context, index) => _buildOptionButton(index),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Navigation Buttons (Fixed at bottom)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.indigo[900]!.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildNavButton(
                          onPressed: _questionIndex == 0 ? null : _previousQuestion,
                          text: 'Previous',
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildNavButton(
                          onPressed: _questionIndex < widget.questions.length - 1
                              ? _nextQuestion
                              : _finishQuiz,
                          text: _questionIndex < widget.questions.length - 1 ? 'Next' : 'Finish',
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
