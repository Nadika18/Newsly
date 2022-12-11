import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Padding(
          padding: EdgeInsets.fromLTRB(0, 300, 0, 300),
          child: Text('Newsly',
              style: TextStyle(
                fontFamily: 'Kalam',
                fontSize: 35,
                color: Colors.white,
              )),
        )),
      ),
    );
  }
}
