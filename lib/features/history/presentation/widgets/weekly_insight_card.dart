import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

class WeeklyInsightCard extends StatelessWidget {
  const WeeklyInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlue.shade50,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightBlue.shade400, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Iconsax.chart_2, size: 32, color: Colors.lightBlue),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Insight Mingguan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue.shade900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Skor CV Anda meningkat 15 poin dalam 2 minggu terakhir! 🚀',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.lightBlue.shade800,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: AppSizes.md),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue.shade500,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Lihat Detail Progress'),
          ),
        ],
      ),
    );
  }
}
