import 'package:flutter/material.dart';
import 'package:food_recognizer_app/ui/home_page.dart';

class NotPredictedPage extends StatelessWidget {
  const NotPredictedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Not Found',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.food_bank_outlined, size: 36, color: Color(0xff00a572)),
            SizedBox(height: 8),
            Text(
              "Hmm, gambar ini belum bisa dikenali. Coba foto ulang dengan pencahayaan lebih baik.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              child: Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }
}
