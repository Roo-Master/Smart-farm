import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _CropCard extends StatelessWidget {
  final String cropName;
  final String stage;
  final String health;

  const _CropCard({required this.cropName, required this.stage, required this.health});

  @override
  Widget build(BuildContext context) {
    Color healthColor = health == "Healthy" ? Colors.green : Colors.red;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(cropName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Growth Stage: $stage"),
            Text("Health: $health", style: TextStyle(color: healthColor)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Get Advice"),
        ),
      ),
    );
  }
}