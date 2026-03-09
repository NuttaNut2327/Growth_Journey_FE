import 'package:fe/api/location/createByUrl.dart';
import 'package:fe/api/location/createByUser.dart';
import 'package:fe/pages/map/models/check_location_model.dart';

class CheckLocationRepository {
  Future<CheckLocation?> getLocationFromLink(String locationLink) async {
    try {
      final result = await createLocationByUrl(locationLink);
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<void> createLocationRequest({
    required String name,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required String type,
  }) async {
    await createLocationByUser(
      name: name,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      type: type,
    );
  }
}
