import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controllers/game_controller.dart';
import 'core/app_constants.dart';
import 'core/app_theme.dart';
import 'core/audio_manager.dart';
import 'models/game_status.dart';
import 'views/game_play_view.dart';
import 'views/level_select_view.dart';
import 'views/main_menu_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style (transparent status bar for full-screen immersive gaming)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Preferred orientations: allow portrait and reverse portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize audio manager
  await AudioManager.instance.init();

  runApp(const Sparrow3DApp());
}

class Sparrow3DApp extends StatelessWidget {
  const Sparrow3DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainGameNavigation(),
    );
  }
}

class MainGameNavigation extends StatefulWidget {
  const MainGameNavigation({super.key});

  @override
  State<MainGameNavigation> createState() => _MainGameNavigationState();
}

class _MainGameNavigationState extends State<MainGameNavigation> {
  late final GameController _gameController;
  bool _isLevelSelectOpen = false;

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
  }

  @override
  void dispose() {
    _gameController.dispose();
    AudioManager.instance.dispose();
    super.dispose();
  }

  void _openLevelSelect() {
    setState(() {
      _isLevelSelectOpen = true;
    });
  }

  void _closeLevelSelect() {
    setState(() {
      _isLevelSelectOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _gameController,
      builder: (context, _) {
        // If playing, paused, gameOver or levelCompleted -> show GamePlayView
        if (_gameController.gameState != GameState.menu) {
          return GamePlayView(controller: _gameController);
        }

        // If level selector is open
        if (_isLevelSelectOpen) {
          return LevelSelectView(
            controller: _gameController,
            onBack: _closeLevelSelect,
          );
        }

        // Default Main Menu
        return MainMenuView(
          controller: _gameController,
          onOpenLevelSelect: _openLevelSelect,
        );
      },
    );
  }
}
