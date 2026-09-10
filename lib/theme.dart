import 'package:flutter/material.dart';

const primaryColor = Color(0xff87cefa);
const coral = primaryColor; // alias for existing screens

Widget roundIcon(IconData icon, {Color? color}) => CircleAvatar(
      radius: 17,
      backgroundColor: Colors.grey.shade100,
      child: Icon(icon, size: 19, color: color ?? Colors.grey.shade700),
    );

Widget guide(String title, String image) => Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              'https://images.unsplash.com/$image?w=300',
              height: 88,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

Widget stepCard(String title, String subtitle, String action) => Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                action,
                style: const TextStyle(
                  color: Color(0xff3779db),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
