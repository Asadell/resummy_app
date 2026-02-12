import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';

@RoutePage()
class InterviewSetupConfirmationScreen extends StatelessWidget {
  const InterviewSetupConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const InterviewSetupStep4Route()),
        ),
      ),
      body: SafeArea(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.setting_2,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Confirm Setup',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'This screen is under construction',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => context.router.push(const InterviewSessionOpeningRoute()),
                child: const Text('Mulai Interview Sekarang! →'),
              ),
            ),
        ],
        ),
      ),
      ),
    );
  }
}
