import 'package:flutter/material.dart';

class EncoderPage extends StatelessWidget {
  const EncoderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EncoderView();
  }
}

class EncoderView extends StatelessWidget {
  const EncoderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO(0w): Dynamically update title text
      appBar: AppBar(title: const Text('current sstv mode')),
      body: const Center(child: Center(child: Text('Placeholder'))),
    );
  }
}
