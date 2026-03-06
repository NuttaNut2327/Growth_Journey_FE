import 'package:fe/pages/map/models/check_location_model.dart';

class CheckLocationRepository {

  final Map<String, List<CheckLocation>> _mockCheckInformation = {
    'https://www.google.com/maps/place/%E0%B8%AA%E0%B8%A7%E0%B8%99%E0%B8%AA%E0%B8%A1%E0%B9%80%E0%B8%94%E0%B9%87%E0%B8%88%E0%B8%9E%E0%B8%A3%E0%B8%B0%E0%B8%99%E0%B8%B2%E0%B8%87%E0%B9%80%E0%B8%88%E0%B9%89%E0%B8%B2%E0%B8%AA%E0%B8%B4%E0%B8%A3%E0%B8%B4%E0%B8%81%E0%B8%B4%E0%B8%95%E0%B8%B4%E0%B9%8C%E0%B8%AF/@13.8044806,100.5507556,16.49z/data=!4m6!3m5!1s0x30e29c6bb9b78789:0x1d0100b33d460260!8m2!3d13.8075119!4d100.5505577!16zL20vMDZ3X3J3?entry=ttu&g_ep=EgoyMDI2MDMwMi4wIKXMDSoASAFQAw%3D%3D': [
      CheckLocation(
        name: "Queen Sirikit Botanic Garden",
        address: "Kamphaeng Phet 2 Road, Chatuchak, Bangkok 10900, Thailand",
        latitude: 13.8075119,
        longitude: 100.5505577,
      ),
    ],
  };

  Future<CheckLocation?> getLocationFromLink(String locationLink) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate network
    return _mockCheckInformation[locationLink]?.first;
  }
}
