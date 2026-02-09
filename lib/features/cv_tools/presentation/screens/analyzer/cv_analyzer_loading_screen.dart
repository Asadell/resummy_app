import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';

@RoutePage()
class CvAnalyzerLoadingScreen extends StatefulWidget {
  const CvAnalyzerLoadingScreen({super.key});

  @override
  State<CvAnalyzerLoadingScreen> createState() =>
      _CvAnalyzerLoadingScreenState();
}

class _CvAnalyzerLoadingScreenState extends State<CvAnalyzerLoadingScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CvAnalyzerProvider>().analyzeCv();

      if (mounted) {
        context.router.push(const CvAnalyzerResultRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Analyzing CV, please wait...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ]),
        ),
      ),
    );
  }
}
