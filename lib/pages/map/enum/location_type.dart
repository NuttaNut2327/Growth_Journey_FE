import 'package:flutter/material.dart';

enum LocationType {
  clinic('Psychologist Clinic'),
  park('Parks and green spaces'),
  museum('Museums and art galleries'),
  cafe('Cafe'),
  library('Library'),
  other('Other');

  final String label;
  const LocationType(this.label);
}

extension LocationTypeExtension on LocationType {
  Color get color {
    switch (this) {
      case LocationType.clinic:
        return const Color(0xFFFFEBB3); // pastel red
      case LocationType.park:
        return const Color(0xFFC8E5D8); // pastel green
      case LocationType.museum:
        return const Color(0xFFD4C8E5); // pastel purple
      case LocationType.cafe:
        return const Color(0xFFFFD4A3); // pastel orange
      case LocationType.library:
        return const Color(0xFFB8D4F1); // pastel blue
      case LocationType.other:
        return const Color(0xFFF5D7E3); // pastel gray
    }
  }
}