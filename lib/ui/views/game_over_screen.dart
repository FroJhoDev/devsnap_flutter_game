import 'package:flutter/material.dart';
import 'main_menu_screen.dart';

class GameOverScreen extends StatelessWidget {
  final String winner;

  const GameOverScreen({super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    final isWin = winner == 'Player';

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isWin ? 'VICTORY!' : (winner == 'Draw' ? 'DRAW' : 'DEFEAT'),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: isWin
                    ? Colors.green
                    : (winner == 'Draw' ? Colors.white : Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Winner: $winner',
              style: const TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MainMenuScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'BACK TO MENU',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
