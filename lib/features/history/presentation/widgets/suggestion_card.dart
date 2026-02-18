import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade50,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade600, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Iconsax.lamp_on, size: 32, color: Colors.amber),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Saran Perbaikan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Sudah 2x revisi CV untuk posisi PM. Waktunya coba simulasi interview?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.amber.shade900,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: AppSizes.md),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Mulai Latihan →'),
          ),
        ],
      ),
    );
  }
}
