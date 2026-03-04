import 'package:fe/widgets/mainUpperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fe/pages/map/models/location_model.dart';
import 'package:fe/pages/map/enum/location_type.dart';
import 'package:fe/pages/map/repository/location_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fe/routes/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:fe/widgets/locationDetailCard.dart';
import 'package:fe/widgets/activityCard.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;

  LocationType? selectedFilter;
  String searchText = "";

  late LocationRepository _repository;
  List<Location> places = [];
  bool isLoading = true;

  Set<Marker> _buildMarkers() {
    final filtered = places.where((place) {
      final matchSearch =place.name.toLowerCase().contains(searchText.toLowerCase());

      final matchType = selectedFilter == null || place.type == selectedFilter;

      return matchSearch && matchType;
    }).toList();

    return filtered.map((place) {
      return Marker(
        markerId: MarkerId(place.id),
        position: LatLng(
          double.parse(place.latitude), 
          double.parse(place.longitude),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerColor(place.type),
        ),
        onTap: () => _showPlaceDetail(place),
      );
    }).toSet();
  }

  double _getMarkerColor(LocationType type) {
  switch (type) {
    case LocationType.clinic:
      return 55;
    case LocationType.park:
      return 120;
    case LocationType.museum:
      return 270;
    case LocationType.cafe:
      return 35;
    case LocationType.library:
      return 200;
    case LocationType.other:
      return 350;
    }
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darker.toColor();
  }

  Widget _buildTag(LocationType type) {
    final isSelected = selectedFilter == type;
    final color = type.color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = isSelected ? null : type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _darken(color, 0.2) : Colors.transparent,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          type.label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
      _repository = LocationRepository();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final data = await _repository.getLocations();
    setState(() {
      places = data;
      isLoading = false;
    });
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();

    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  void _showPlaceDetail(Location place) {
    final color = place.type.color; 

    showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.35,   
        minChildSize: 0.35,
        maxChildSize: 1.0,       
        expand: false,           
        builder: (context, controller) {
          return SafeArea(     
            top: false,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6EEF5),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  LocationDetailcard(
                    place: place,
                    tagColor: color,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Organized activities",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ActivityCard(),
                  const SizedBox(height: 16),
                  ActivityCard(),
                  const SizedBox(height: 16),
                  ActivityCard(),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createLocation);
        },
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01, 
          size: 24,
          strokeWidth: 2,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFFD8A7D9),
        shape: const CircleBorder(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(13.7563, 100.5018),
                    zoom: 14,
                  ),
                  markers: _buildMarkers(),
                  onMapCreated: (controller) {
                    _controller = controller;
                    _goToCurrentLocation();
                  },
                  zoomControlsEnabled: false,   // ปิดปุ่ม + -
                  zoomGesturesEnabled: true,    // เปิด pinch zoom
                  scrollGesturesEnabled: true,  // ลากได้
                  rotateGesturesEnabled: true,  // หมุนได้ (ถ้าอยากให้หมุน)
                  tiltGesturesEnabled: true,    // เอียงได้ (ถ้าอยากให้เอียง)
                  mapToolbarEnabled: false,
                ),
    
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: MainUpperNavBar(),
                ),
                
                Positioned(
                  top: 150,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 50,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: IntrinsicWidth(
                            child: Row(
                              mainAxisSize: MainAxisSize.min, 
                              children: [
                                _buildTag(LocationType.clinic),
                                const SizedBox(width: 10),
                                _buildTag(LocationType.park),
                                const SizedBox(width: 10),
                                _buildTag(LocationType.museum),
                                const SizedBox(width: 10),
                                _buildTag(LocationType.cafe),
                                const SizedBox(width: 10),
                                _buildTag(LocationType.library),
                                const SizedBox(width: 10),
                                _buildTag(LocationType.other),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
}