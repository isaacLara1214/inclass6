import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;
  String milestone = '';
  int milestoneValue = 0;

  void checkMilestone() {
    if (value >= 0 && value <= 12) {
      milestone = 'Youre a child';
      milestoneValue = 1;
    } else if (value >= 13 && value <= 19) {
      milestone = 'Teenager time!';
      milestoneValue = 2;
    } else if (value >= 20 && value <= 30) {
      milestone = "You're a young adult!";
      milestoneValue = 3;
    } else if (value >= 31 && value <= 50) {
      milestone = "You're an adult now!";
      milestoneValue = 4;
    } else if (value >= 50) {
      milestone = 'Golden years!';
      milestoneValue = 5;
    }
  }

  void increment() {
    value += 1;
    checkMilestone();
    notifyListeners();
  }

  void decrement() {
    if (value == 0) {
      return;
    }
    value -= 1;
    checkMilestone();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        Color appBarColor;
        Color buttonColor;

        switch (counter.milestoneValue) {
          case 1:
            appBarColor = Colors.blue;
            buttonColor = Colors.blue;
            break;
          case 2:
            appBarColor = Colors.green;
            buttonColor = Colors.green;
            break;
          case 3:
            appBarColor = Colors.orange;
            buttonColor = Colors.orange;
            break;
          case 4:
            appBarColor = Colors.red;
            buttonColor = Colors.red;
            break;
          case 5:
            appBarColor = Colors.purple;
            buttonColor = Colors.purple;
            break;
          default:
            appBarColor = Colors.blue;
            buttonColor = Colors.blue;
        }

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  get style => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                'I am ${counter.value} years old',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ElevatedButton(
                style: style,
                onPressed: () {
                  var counter = context.read<Counter>();
                  counter.increment();
                },
                child: const Text('Increase Age')),
            ElevatedButton(
                style: style,
                onPressed: () {
                  var counter = context.read<Counter>();
                  counter.decrement();
                },
                child: const Text('Decrease Age')),
          ],
        ),
      ),
    );
  }
}
