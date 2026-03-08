import 'package:fe/api/location/getApprovedLocations.dart';
import 'package:fe/pages/map/models/location_model.dart';

class LocationRepository {
  Future<List<Location>> getLocations() async {
    final locations = await getApprovedLocations();
    return locations;
  }
}
