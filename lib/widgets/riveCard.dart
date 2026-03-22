import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ExampleRiveBuilder extends StatefulWidget {
  final String mood;
  final int level;

  const ExampleRiveBuilder({
    super.key,
    required this.mood,
    required this.level,
  });

  @override
  State<ExampleRiveBuilder> createState() => _ExampleRiveBuilderState();
}

class _ExampleRiveBuilderState extends State<ExampleRiveBuilder> {
  late final FileLoader fileLoader;

  @override
  void initState() {
    super.initState();

    String assetPath = "assets/animations/${widget.mood}_level_${widget.level}.riv";

    fileLoader = FileLoader.fromAsset(
      assetPath,
      riveFactory: Factory.rive,
    );
  }

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      builder: (context, state) => switch (state) {
        RiveLoading() => const Center(child: CircularProgressIndicator()),
        RiveFailed() => ErrorWidget.withDetails(
            message: state.error.toString(),
            error: FlutterError(state.error.toString()),
          ),
        RiveLoaded() => RiveWidget(
            controller: state.controller,
            fit: Fit.contain,
          )
      },
    );
  }
}