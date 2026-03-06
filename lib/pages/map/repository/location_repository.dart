import 'package:fe/pages/map/models/location_model.dart';
import 'package:fe/pages/map/enum/location_type.dart';

class LocationRepository {
  final List<Location> _mockLocations = [
    Location(
      id: "1",
      name: "Thai Commemorative Garden",
      description: "A peaceful garden in the heart of Bangkok",
      latitude: 13.8442608,
      longitude: 100.571461,
      type: LocationType.park,
    ),
    Location(
      id: "2",
      name: "KU Happy Place Center",
      description: "Mental health support center at Kasetsart University",
      latitude: 13.8463013,
      longitude: 100.5664825,
      type: LocationType.clinic,
    ),
    Location(
      id: "3",
      name: "Moca Museum",
      description: "Modern art museum",
      latitude: 13.8523198,
      longitude: 100.5604343,
      type: LocationType.museum,
    ),
    Location(
      id: "4",
      name: "KU Library",
      description: "University library with extensive resources",
      latitude: 13.8454238,
      longitude: 100.5677717,
      type: LocationType.library,
    ),
    Location(
      id: "5",
      name: "Brain Cafe' & Coworking Space",
      description: "Cafe and coworking space for mental wellness",
      latitude: 13.8445412,
      longitude: 100.5697491,
      type: LocationType.cafe,
    ),
  ];

   Future<List<Location>> getLocations() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockLocations;
  }
}