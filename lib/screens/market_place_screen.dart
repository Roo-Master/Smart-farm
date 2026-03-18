import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final crops = [
      {"name": "Tomatoes", "price": "KES 4,000", "location": "Nairobi"},
      {"name": "Maize", "price": "KES 3,100", "location": "Eldoret"},
      {"name": "Avocados", "price": "KES 8,000", "location": "Kisumu"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Marketplace")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: crops.length,
        itemBuilder: (context, index) {
          final crop = crops[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(crop['name']!),
              subtitle: Text("${crop['price']}/unit - ${crop['location']}"),
              trailing: ElevatedButton(onPressed: () {}, child: const Text("Place Order")),
            ),
          );
        },
      ),
    );
  }
}

