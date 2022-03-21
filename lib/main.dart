import 'package:flutter/material.dart';

void main() {
  runApp(const Spitch());
}

class Spitch extends StatelessWidget {
  const Spitch({Key? key}) : super(key: key);

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPITCH',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF33BA49)),
      ),
      home: const RecommendedLineup(title: 'Recommended Lineup'),
    );
  }
}

class RecommendedLineup extends StatefulWidget {
  const RecommendedLineup({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RecommendedLineup> createState() => _RecommendedLineupState();
}

class _RecommendedLineupState extends State<RecommendedLineup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(),
      ),
    );
  }
}
