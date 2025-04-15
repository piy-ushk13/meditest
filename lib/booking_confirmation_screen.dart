import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'theme.dart';
import 'utils/map_utils.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSuccessAnimation(),
                      const SizedBox(height: 24),
                      _buildAppointmentDetails(),
                      const SizedBox(height: 24),
                      _buildMapPreview(),
                    ],
                  ),
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Booking Confirmed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildSuccessAnimation() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(
                  begin: 0.5,
                  end: 0,
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
            Icon(
              Icons.check_circle,
              color: AppTheme.successColor,
              size: 80,
            )
                .animate()
                .fadeIn(
                  delay: 200.ms,
                  duration: 200.ms,
                )
                .slideY(
                  begin: 0.5,
                  end: 0,
                  delay: 200.ms,
                  duration: 700.ms,
                  curve: Curves.elasticOut,
                ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Appointment Booked Successfully!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 500.ms).slideY(
              begin: 0.3,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOutQuad,
            ),
        const SizedBox(height: 8),
        Text(
          'Your appointment has been scheduled',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(
              delay: 200.ms,
              duration: 500.ms,
            )
            .slideY(
              begin: 0.3,
              end: 0,
              delay: 200.ms,
              duration: 500.ms,
              curve: Curves.easeOutQuad,
            ),
      ],
    );
  }

  Widget _buildAppointmentDetails() {
    return Container(
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
          _buildDetailItem(
            icon: Icons.person,
            title: 'Doctor',
            value: 'Dr. Wesley Cain',
          ),
          const Divider(height: 24),
          _buildDetailItem(
            icon: Icons.medical_services,
            title: 'Specialization',
            value: 'Pulmonologist',
          ),
          const Divider(height: 24),
          _buildDetailItem(
            icon: Icons.calendar_today,
            title: 'Date & Time',
            value: 'Sunday, 28 Feb, 4:30 PM',
          ),
          const Divider(height: 24),
          _buildDetailItem(
            icon: Icons.location_on,
            title: 'Location',
            value: 'St. Memorial Hospital',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    const hospitalLocation = LatLng(37.7749, -122.4194);
    final Set<Marker> markers = {
      const Marker(
        markerId: MarkerId('hospital'),
        position: hospitalLocation,
        infoWindow: InfoWindow(
          title: 'St. Memorial Hospital',
          snippet: 'Your appointment location',
        ),
      ),
    };

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: hospitalLocation,
                zoom: 15,
              ),
              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: FloatingActionButton.small(
                onPressed: () {
                  MapUtils.openMap(
                    hospitalLocation,
                    destinationName: 'St. Memorial Hospital',
                  ).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.directions,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .moveY(
          begin: 50,
          duration: 500.ms,
          curve: Curves.easeOutQuad,
        )
        .fadeIn(duration: 500.ms);
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Book Another',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
