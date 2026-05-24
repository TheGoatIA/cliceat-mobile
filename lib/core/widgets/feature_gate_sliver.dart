import 'package:cliceat_app/core/config/presentation/bloc/config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureGateSliver extends StatelessWidget {
  final String featureKey;
  final Widget child; // This must be a sliver

  const FeatureGateSliver({
    super.key,
    required this.featureKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        final isEnabled = context.read<ConfigBloc>().isFeatureEnabled(featureKey);
        if (isEnabled) {
          return child;
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
