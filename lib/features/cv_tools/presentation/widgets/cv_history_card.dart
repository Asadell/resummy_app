import 'package:flutter/material.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_card.dart';

class CvHistoryCard extends StatelessWidget {
  final CVData cv;
  final int index;

  const CvHistoryCard({
    super.key,
    required this.cv,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return CVCard(
      cv: cv,
      index: index,
    );
  }
}
