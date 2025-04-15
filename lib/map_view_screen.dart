import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/error_view.dart';
import 'widgets/page_transitions.dart';
import 'doctor_details_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  bool _showTooltip = false;
  LatLng? _selectedLocation;
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'All Doctors';
  bool _isMapTypeNormal = true;

  final List<String> _filters = [
    'All Doctors',
    'Cardiologists',
    'Neurologists',
    'Pulmonologists',
    'Pediatricians',
  ];

  final List<Map<String, dynamic>> _doctorsData = [
    {
      'name': 'Dr. Wesley Cain',
      'specialty': 'Pulmonologist',
      'location': const LatLng(37.7749, -122.4194),
      'rating': 4.5,
      'availableTime': '4:30 PM',
      'image': 'https://placeholder.com/100',
    },
    {
      'name': 'Dr. Sarah Wilson',
      'specialty': 'Cardiologist',
      'location': const LatLng(37.7833, -122.4167),
      'rating': 4.8,
      'availableTime': '3:30 PM',
      'image': 'https://placeholder.com/100',
    },
    {
      'name': 'Dr. Michael Brown',
      'specialty': 'Neurologist',
      'location': const LatLng(37.7814, -122.4216),
      'rating': 4.6,
      'availableTime': '5:00 PM',
      'image': 'https://placeholder.com/100',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      _initializeMarkers();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load map data. Please try again.';
      });
    }
  }

  void _initializeMarkers() {
    for (final doctor in _doctorsData) {
      final markerId = MarkerId(doctor['name']);
      _markers.add(
        Marker(
          markerId: markerId,
          position: doctor['location'],
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onTap: () {
            setState(() {
              _selectedLocation = doctor['location'];
              _showTooltip = true;
            });
            _mapController.animateCamera(
              CameraUpdate.newLatLngZoom(doctor['location'], 15),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(),
          Column(
            children: [
              _buildHeader(),
              _buildFilterChips(),
            ],
          ),
          if (_showTooltip && _selectedLocation != null)
            _buildTooltip()
                .animate()
                .slideY(
                  begin: 1,
                  end: 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                )
                .fadeIn(
                  duration: const Duration(milliseconds: 200),
                ),
          _buildMapControls(),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      right: 16,
      bottom: _showTooltip ? 240 : 32,
      child: Column(
        children: [
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                _isMapTypeNormal = !_isMapTypeNormal;
              });
              _mapController
                  .setMapStyle(_isMapTypeNormal ? null : _darkMapStyle);
            },
            backgroundColor: Colors.white,
            child: Icon(
              _isMapTypeNormal ? Icons.map_outlined : Icons.map,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.zoomIn(),
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.zoomOut(),
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.remove,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 200),
        );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingIndicator(
        message: 'Loading map...',
      );
    }

    if (_error != null) {
      return ErrorView(
        message: _error!,
        actionLabel: 'Retry',
        onActionPressed: _loadMapData,
      );
    }

    return _buildMap();
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(37.7749, -122.4194),
        zoom: 14,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        _setMapStyle();
      },
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      onTap: (position) {
        setState(() {
          _showTooltip = false;
        });
      },
    );
  }

  Future<void> _setMapStyle() async {
    const style = [
      {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels",
        "stylers": [
          {"visibility": "off"}
        ]
      }
    ];
    await _mapController.setMapStyle(style.toString());
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search nearby doctors',
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune, color: Colors.white),
                            onPressed: () {
                              // Show filters
                            },
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        // Implement search
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters.map((filter) {
          return _buildFilterChip(filter, filter == _selectedFilter);
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = label;
          });
          // Implement filter logic
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryColor.withOpacity(0.1),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color:
              isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    final doctor = _doctorsData.firstWhere(
      (d) => d['location'] == _selectedLocation,
    );

    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          context.pushWithTransition(
            const DoctorDetailsScreen(),
            transitionType: 'slide',
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(doctor['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor['specialty'],
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor['rating'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor['availableTime'],
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.pushWithTransition(
                    const DoctorDetailsScreen(),
                    transitionType: 'slide',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String _darkMapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#242f3e"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#746855"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#242f3e"
          }
        ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#263c3f"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#6b9a76"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#38414e"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#212a37"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9ca5b3"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#746855"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#1f2835"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#f3d19c"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#2f3948"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#17263c"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#515c6d"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#17263c"
          }
        ]
      }
    ]
  ''';

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
