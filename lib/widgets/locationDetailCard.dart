import 'package:flutter/material.dart';
import 'package:fe/pages/map/models/location_model.dart';

class LocationDetailcard extends StatelessWidget {
  final Location place;
  final Color tagColor;

  const LocationDetailcard({
    super.key,
    required this.place,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF7EDF7),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  place.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  place.type.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4A4458),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Text(
            place.address,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8B7A99),
            ),
          ),
          if (place.description != null && place.description != "null") ...[
            const SizedBox(height: 12),
            Text( place.description!),
          ] else if (place.description == null || place.description == "null") ...[
            const Text(""),
          ],
        ],
      ),
    );
  }
}