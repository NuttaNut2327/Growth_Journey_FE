import 'package:fe/pages/map/models/location_model.dart';
import 'package:fe/pages/map/enum/location_type.dart';

class LocationRepository {
  final List<Location> _mockLocations = [
    Location(
      id: "1",
      name: "Thai Commemorative Garden",
      address: "Suan Luang Rama IX, Bangkok",
      description: "A peaceful garden in the heart of Bangkok",
      latitude: 13.8419357,
      longitude: 100.5699994,
      type: LocationType.park,
    ),
    Location(
      id: "2",
      name: "KU Happy Place Center",
      address: "Kasetsart University, Bangkok",
      description: "Mental health support center at Kasetsart University",
      latitude: 13.8496573,
      longitude: 100.5688655,
      type: LocationType.clinic,
    ),
    Location(
      id: "3",
      name: "Moca Museum",
      address: "Bangkok Art and Culture Centre, Bangkok",
      description: "Modern art museum showcasing contemporary works by Thai and international artists.",
      latitude: 13.8523198,
      longitude: 100.5604343,
      type: LocationType.museum,
    ),
    Location(
      id: "4",
      name: "KU Library",
      address: "Kasetsart University, Bangkok",
      description: "University library with extensive resources",
      latitude: 13.8476171,
      longitude: 100.5718701,
      type: LocationType.library,
    ),
    Location(
      id: "5",
      name: "Brain Cafe' & Coworking Space",
      address: "Suan Luang Rama IX, Bangkok",
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