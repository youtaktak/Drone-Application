// pages/PageMaps.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PageMaps extends StatefulWidget {
  const PageMaps({super.key});

  @override
  _PageMapsState createState() => _PageMapsState();
}

class _PageMapsState extends State<PageMaps> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String _errorMessage = '';

  Future<void> _handleLocationPermission() async {
    // Vérifier si la permission est déjà accordée
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      // Demander la permission de manière interactive
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // Rediriger vers les paramètres de l'appareil
      await openAppSettings();
      setState(() {
        _errorMessage = 'Activez la localisation dans les paramètres';
        _isLoading = false;
      });
      return;
    }

    if (!status.isGranted) {
      setState(() {
        _errorMessage = 'Permission nécessaire pour utiliser cette fonctionnalité';
        _isLoading = false;
      });
      return;
    }

    // Vérifier si le GPS est activé
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() {
        _errorMessage = 'Activez le GPS dans les paramètres';
        _isLoading = false;
      });
      await Geolocator.openLocationSettings();
      return;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _handleLocationPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.add(Marker(
          markerId: const MarkerId('current'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Votre position'),
        ));
        _isLoading = false;
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 14),
      );

    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur : ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi en temps réel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => openAppSettings(),
          ),
        ],
      ),
      body: _buildMapContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }

  Widget _buildMapContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return GoogleMap(
      onMapCreated: (controller) => mapController = controller,
      initialCameraPosition: CameraPosition(
        target: _currentPosition ?? const LatLng(0, 0),
        zoom: 14.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
}