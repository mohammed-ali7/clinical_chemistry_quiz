import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clinical_chemistry_mcqs/models/chapter_model.dart';
import 'package:clinical_chemistry_mcqs/screens/quiz_screen.dart';

// Cache Google Fonts to improve performance
final _titleStyle = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 26,
  letterSpacing: 0.5,
);

final _subtitleStyle = GoogleFonts.poppins(
  color: Colors.white70,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

final _chapterTitleStyle = GoogleFonts.poppins(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 16,
  letterSpacing: 0.2,
  height: 1.2,
);

final _questionCountStyle = GoogleFonts.poppins(
  color: Colors.white70,
  fontSize: 13,
  fontWeight: FontWeight.w400,
);

final _chapterNumberStyle = GoogleFonts.poppins(
  color: Colors.amber[400],
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF1D1E33),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  // AppBar with title and subtitle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Clinical Chemistry MCQs',
                          style: _titleStyle.copyWith(fontSize: 28),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Test your knowledge in Clinical Chemistry with 22 chapters',
                            style: _subtitleStyle.copyWith(fontSize: 18),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  
                  // Chapters List / Grid (responsive)
                  Expanded(
                    child: Consumer<List<Chapter>>(
                      builder: (context, chapters, _) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final useGrid = width >= 900; // switch to grid on wide screens
                            if (!useGrid) {
                              return Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                                  itemCount: chapters.length,
                                  itemExtent: 110,
                                  cacheExtent: 600,
                                  key: const PageStorageKey<String>('chapters_list'),
                                  itemBuilder: (context, index) {
                                    final chapter = chapters[index];
                                    return _ChapterCard(chapter: chapter, index: index);
                                  },
                                ),
                              );
                            }
                            // Grid mode
                            final crossAxisCount = width >= 1200 ? 3 : 2;
                            return Scrollbar(
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 2.8,
                                ),
                                itemCount: chapters.length,
                                itemBuilder: (context, index) {
                                  final chapter = chapters[index];
                                  return _ChapterCard(chapter: chapter, index: index);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final int index;
  
  const _ChapterCard({required this.chapter, required this.index});
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 900 ? 16 : (MediaQuery.of(context).size.width > 600 ? 40 : 12),
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo[800]!,
            Colors.indigo[900]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Use pushNamed with route names for better performance
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => QuizScreen(
                questions: chapter.questions,
                chapterTitle: chapter.title,
              ),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [
                Colors.indigo[700]!,
                Colors.indigo[800]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 900 ? 20.0 : (MediaQuery.of(context).size.width > 600 ? 28.0 : 16.0),
              vertical: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.indigo[600]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: _chapterNumberStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          chapter.title,
                          style: _chapterTitleStyle.copyWith(
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1.0),
                                blurRadius: 2.0,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${chapter.questions.length} Questions',
                        style: _questionCountStyle,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
