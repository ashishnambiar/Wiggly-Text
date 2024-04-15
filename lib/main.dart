import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController ctrl =
      TextEditingController(text: "Hello World!");

  double waveLength = 0.5;
  double waveHeight = 5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: waveLength,
                onChanged: (val) {
                  setState(() {
                    waveLength = val;
                  });
                },
                min: 0,
                max: 1,
              ),
              Slider(
                value: waveHeight,
                onChanged: (val) {
                  setState(() {
                    waveHeight = val;
                  });
                },
                min: 0,
                max: 20,
              ),
              ListenableBuilder(
                listenable: ctrl,
                builder: (context, _) => Column(
                  children: [
                    Text(ctrl.text.length.toString()),
                    WigglyTextWidget(
                      ctrl.text,
                      waveLength: waveLength,
                      waveHeight: waveHeight,
                      duration: const Duration(seconds: 3),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: ctrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WigglyTextWidget extends StatefulWidget {
  const WigglyTextWidget(
    this.text, {
    this.waveLength = 0.5,
    this.waveHeight = 5,
    this.duration = const Duration(seconds: 2),
    super.key,
  });

  final String text;
  final double waveLength;
  final double waveHeight;
  final Duration duration;

  @override
  State<WigglyTextWidget> createState() => _WigglyTextWidgetState();
}

class _WigglyTextWidgetState extends State<WigglyTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    lowerBound: 0,
    upperBound: pi * 2,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return RichText(
          text: TextSpan(
            children: [
              ...List.generate(
                widget.text.length,
                (index) {
                  final offset = sin(
                        controller.value - (widget.waveLength * index),
                      ) *
                      widget.waveHeight;
                  return WidgetSpan(
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        offset,
                      ),
                      child: Text(widget.text[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
