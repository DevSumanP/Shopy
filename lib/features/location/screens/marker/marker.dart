import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/location/screens/marker/new_page.dart';
import 'package:fluttermoji/fluttermoji.dart';

class Marker extends StatelessWidget {
  const Marker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluttermoji'),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const SizedBox(
            height: 25,
          ),
          FluttermojiCircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 100,
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              const Spacer(flex: 2),
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: const Text("Customize"),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NewPage())),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
