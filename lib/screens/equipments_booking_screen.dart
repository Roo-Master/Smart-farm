import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EquipmentBookingScreen extends StatelessWidget {
  const EquipmentBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Equipment Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Book a Tractor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Available on"),
              items: ["April 18, 2022", "April 19, 2022"].map((date) {
                return DropdownMenuItem(value: date, child: Text(date));
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Time"),
              items: ["10:00 AM - 12:00 PM", "12:00 PM - 2:00 PM"].map((time) {
                return DropdownMenuItem(value: time, child: Text(time));
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Implement"),
              items: ["Plough", "Harvester"].map((imp) {
                return DropdownMenuItem(value: imp, child: Text(imp));
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: const Text("Request Tractor"),
            ),
          ],
        ),
      ),
    );
  }
}