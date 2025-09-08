import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KFooter extends StatelessWidget {
  const KFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClassicFooter(
      loadingText: 'Loading...',
      idleText: '',
      failedText: 'Failed',
      noDataText: 'No data',
      canLoadingText: '',
    );
  }
}