import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MySolutionApp());
}

class MySolutionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Solution App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ClassSelectionScreen(),
    );
  }
}

// Screen 1: Class Selection
class ClassSelectionScreen extends StatelessWidget {
  final List<String> classes = ['Class 7', 'Class 8', 'Class 9', 'Class 10'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Solution App')),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(classes[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SubjectScreen(className: classes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Screen 2: Subject Selection
class SubjectScreen extends StatelessWidget {
  final String className;
  final List<String> subjects = ['Math', 'Science', 'English'];

  SubjectScreen({required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$className Subjects')),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChapterScreen(
                        className: className,
                        subject: subjects[index],
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Screen 3: Chapter Selection
class ChapterScreen extends StatelessWidget {
  final String className;
  final String subject;

  ChapterScreen({required this.className, required this.subject});

  final Map<String, Map<String, List<String>>> classChapters = {
    'Class 7': {
      'Math': [
        'Chapter 1: Integers',
        'Chapter 2: Fractions',
        'Chapter 3: Decimals',
      ],
      'Science': [
        'Chapter 1: Nutrition',
        'Chapter 2: Heat',
        'Chapter 3: Motion',
      ],
      'English': [
        'Chapter 1: Nouns',
        'Chapter 2: Verbs',
        'Chapter 3: Adjectives',
      ],
    },
    'Class 8': {
      'Math': [
        'Chapter 1: Rational Numbers',
        'Chapter 2: Linear Equations',
        'Chapter 3: Quadrilaterals',
      ],
      'Science': [
        'Chapter 1: Force',
        'Chapter 2: Pressure',
        'Chapter 3: Sound',
      ],
      'English': [
        'Chapter 1: Tenses',
        'Chapter 2: Comprehension',
        'Chapter 3: Essays',
      ],
    },
    'Class 9': {
      'Math': [
        'Chapter 1: Number Systems',
        'Chapter 2: Polynomials',
        'Chapter 3: Coordinate Geometry',
      ],
      'Science': ['Chapter 1: Matter', 'Chapter 2: Atoms', 'Chapter 3: Motion'],
      'English': ['Chapter 1: Poetry', 'Chapter 2: Prose', 'Chapter 3: Drama'],
    },
    'Class 10': {
      'Math': [
        'Chapter 1: Real Numbers',
        'Chapter 2: Triangles',
        'Chapter 3: Trigonometry',
      ],
      'Science': [
        'Chapter 1: Chemical Reactions',
        'Chapter 2: Electricity',
        'Chapter 3: Light',
      ],
      'English': [
        'Chapter 1: Literature',
        'Chapter 2: Grammar',
        'Chapter 3: Writing Skills',
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final chapterList = classChapters[className]?[subject] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$className - $subject')),
      body: ListView.builder(
        itemCount: chapterList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(chapterList[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SolutionScreen(
                        className: className,
                        subject: subject,
                        chapter: chapterList[index],
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Screen 4: Solution Display with .txt File Loading
class SolutionScreen extends StatefulWidget {
  final String className;
  final String subject;
  final String chapter;

  SolutionScreen({
    required this.className,
    required this.subject,
    required this.chapter,
  });

  @override
  _SolutionScreenState createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  String solutionText = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadSolution();
  }

  Future<void> loadSolution() async {
    try {
      // Generate file name (e.g., class7_math_chapter1.txt)
      String fileName =
          '${widget.className.toLowerCase().replaceAll(" ", "")}_${widget.subject.toLowerCase()}_${widget.chapter.split(":")[0].toLowerCase().replaceAll(" ", "")}.txt';
      String content = await rootBundle.loadString(
        'assets/solutions/$fileName',
      );
      setState(() {
        solutionText = content;
      });
    } catch (e) {
      setState(() {
        solutionText =
            'Error loading solution for ${widget.chapter}: File not found or invalid.\n\nPlease ensure the file exists in assets/solutions/.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.chapter} Solutions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solution for ${widget.className} - ${widget.subject} - ${widget.chapter}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(solutionText, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
