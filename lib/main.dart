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

  double r = 0;
  double g = 0;
  double b = 0;

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
                      r: r,
                      g: g,
                      b: b,
                    ),
                  ],
                ),
              ),
              TextField(
                controller: ctrl,
              ),
              Slider(
                value: r,
                onChanged: (val) {
                  setState(() {
                    r = val;
                  });
                },
                min: 0,
                max: pi,
              ),
              Slider(
                value: g,
                onChanged: (val) {
                  setState(() {
                    g = val;
                  });
                },
                min: 0,
                max: pi,
              ),
              Slider(
                value: b,
                onChanged: (val) {
                  setState(() {
                    b = val;
                  });
                },
                min: 0,
                max: pi,
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
    this.r = 5,
    this.g = 5,
    this.b = 5,
    super.key,
  });

  final String text;
  final double waveLength;
  final double waveHeight;
  final Duration duration;

  final double r;
  final double g;
  final double b;

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
  double range([double? phase]) =>
      ((sin(controller.value - (phase ?? 0)) + 1) * .5);

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
                      child: Text(
                        widget.text[index],
                        style: TextStyle(
                          color: Color.fromARGB(
                            255,
                            ((range((widget.waveLength * index) +
                                            (pi * widget.r)) *
                                        195) +
                                    50)
                                .toInt(),
                            ((range((widget.waveLength * index) +
                                            (pi * widget.g)) *
                                        195) +
                                    50)
                                .toInt(),
                            ((range((widget.waveLength * index) +
                                            (pi * widget.b)) *
                                        195) +
                                    50)
                                .toInt(),
                          ),
                          fontSize: 20,
                          // animation for `fontVariations` have been disabled
                          // because of bad performance
                          // This, is due the layout of the `Text` needing to
                          // be calculated every time there is a change in the
                          // `fontVariations` which is very ridiculous

                          /* 
                          fontFamily: 'Roboto-Flex',
                          fontVariations: [
                            FontVariation.slant(
                                (range(widget.waveLength * index) * 10) - 10),
                            FontVariation.weight(
                                (range(widget.waveLength * index) * 900) + 100),
                            FontVariation(
                                'XTRA',
                                ((range(widget.waveLength * index * (pi / 2)) *
                                        280) +
                                    323)),
                            FontVariation('YTAS',
                                (range(widget.waveLength * index) * 205) + 649),
                            FontVariation('YTLC',
                                (range(widget.waveLength * index) * 154) + 416),
                          ], */
                        ),
                      ),
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
