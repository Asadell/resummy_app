import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderStep6Screen extends StatelessWidget {
  const CvBuilderStep6Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.summary),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.push(const CvBuilderStep5Route()),
        ),
      ),
      body: SafeArea(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.setting_3,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.summary,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.screenUnderConstruction,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   TextButton(
                    onPressed: () => context.router.push(const CvBuilderStep7Route()),
                    child: Text(l10n.skip),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                    onPressed: () => context.router.push(const CvBuilderStep7Route()),
                    child: Text('${l10n.next} →'),
                  ),
                ],
              ),
            ),
         ],
        ),
      ),
      ),
    );
  }
}
