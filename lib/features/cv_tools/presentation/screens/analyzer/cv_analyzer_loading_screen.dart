import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class CvAnalyzerLoadingScreen extends StatefulWidget {
  const CvAnalyzerLoadingScreen({super.key});

  @override
  State<CvAnalyzerLoadingScreen> createState() => _CvAnalyzerLoadingScreenState();
}

class _CvAnalyzerLoadingScreenState extends State<CvAnalyzerLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.router.push(const CvAnalyzerResultRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Analyzing CV...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
