import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/itinerary_trip_models.dart';
import '../services/google_maps_service.dart';
import '../theme.dart';

class PlaceDetailDialog extends StatefulWidget {
  final ItineraryPlaceStop stop;
  final VoidCallback? onRemove;

  const PlaceDetailDialog({
    super.key,
    required this.stop,
    this.onRemove,
  });

  static Future<void> show(BuildContext context, ItineraryPlaceStop stop, {VoidCallback? onRemove}) {
    return showDialog(
      context: context,
      builder: (ctx) => PlaceDetailDialog(stop: stop, onRemove: onRemove),
    );
  }

  @override
  State<PlaceDetailDialog> createState() => _PlaceDetailDialogState();
}

class _PlaceDetailDialogState extends State<PlaceDetailDialog> {
  bool showStreetView = false;
  bool showFullHours = false;

  @override
  Widget build(BuildContext context) {
    final stop = widget.stop;
    final googleData = GoogleMapsService.getPlaceDetails(stop);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // HEADER: Photo / Google Street View Switcher
              // ------------------------------------------------
              Stack(
                children: [
                  if (showStreetView)
                    Container(
                      height: 180,
                      width: double.infinity,
                      color: const Color(0xFF0F172A),
                      child: Image.network(
                        GoogleMapsService.getStreetViewUrl(lat: stop.lat, lng: stop.lng),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.streetview, color: Colors.white70, size: 36),
                              const SizedBox(height: 6),
                              Text('Street View for ${stop.name}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0F172A),
                            coral.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(stop.categoryIcon, style: const TextStyle(fontSize: 48)),
                            const SizedBox(height: 6),
                            Text(
                              stop.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Close button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.white),
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Priority Tag
                  if (stop.isHighlight)
                    Positioned(
                      top: 12,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFF59E0B)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('⭐ ', style: TextStyle(fontSize: 10)),
                            Text(
                              'PRIORITY STOP',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB45309),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Street View Toggle Button on Header
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: FilledButton.tonalIcon(
                      onPressed: () => setState(() => showStreetView = !showStreetView),
                      icon: Icon(showStreetView ? Icons.image : Icons.streetview, size: 14),
                      label: Text(
                        showStreetView ? 'Show Category' : 'Street View 📷',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.65),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      stop.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Google Maps Verified Rating & Reviews
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 11, color: Color(0xFF2563EB)),
                              SizedBox(width: 4),
                              Text(
                                'Google Maps Verified',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF)),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${googleData.rating}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${googleData.userRatingsTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Google reviews)',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Quick Meta Badges (Time, Duration, Cost)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInfoPill(Icons.access_time, 'Scheduled: ${stop.time}'),
                        _buildInfoPill(Icons.timelapse, 'Duration: ${stop.duration}'),
                        _buildInfoPill(Icons.payments_outlined, stop.estimatedCost),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'About this place',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stop.description,
                      style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.45),
                    ),
                    const SizedBox(height: 16),

                    // Why TripNest Recommends It (AI grounded in Notebook)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: coral.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('🪺 ', style: TextStyle(fontSize: 14)),
                              Text(
                                'WHY TRIPNEST RECOMMENDS IT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: coral,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            stop.whyRecommended,
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF7C2D12), height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ------------------------------------------------
                    // GOOGLE MAPS PLACE INFORMATION SECTION
                    // ------------------------------------------------
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.place, size: 14, color: Color(0xFFEA4335)),
                              SizedBox(width: 6),
                              Text(
                                'GOOGLE MAPS INFORMATION',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF475569),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Formatted Address with Copy Action
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF64748B)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  googleData.formattedAddress,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: googleData.formattedAddress));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Address copied to clipboard!'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.copy, size: 14, color: Color(0xFF94A3B8)),
                                ),
                              ),
                            ],
                          ),

                          // Phone number if available
                          if (googleData.phoneNumber != null) ...[
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () => GoogleMapsService.launchExternalUrl('tel:${googleData.phoneNumber!}'),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF64748B)),
                                  const SizedBox(width: 6),
                                  Text(
                                    googleData.phoneNumber!,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Website if available
                          if (googleData.website != null) ...[
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () => GoogleMapsService.launchExternalUrl(googleData.website!),
                              child: Row(
                                children: [
                                  const Icon(Icons.language, size: 14, color: Color(0xFF64748B)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      googleData.website!,
                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF2563EB), decoration: TextDecoration.underline),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Opening Hours
                          if (googleData.weekdayHours.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => setState(() => showFullHours = !showFullHours),
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule, size: 14, color: Color(0xFF10B981)),
                                  const SizedBox(width: 6),
                                  Text(
                                    googleData.isOpenNow == true ? 'Open Now' : 'Schedule',
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF047857), fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      googleData.weekdayHours.first,
                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    showFullHours ? Icons.expand_less : Icons.expand_more,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            if (showFullHours)
                              Padding(
                                padding: const EdgeInsets.only(top: 6, left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: googleData.weekdayHours
                                      .map((h) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 1.5),
                                            child: Text(h, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                          ))
                                      .toList(),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Travel Method to next stop
                    Row(
                      children: [
                        const Icon(Icons.directions_walk, size: 16, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Transit to next stop: ${stop.travelMethod} (${stop.distanceToNext})',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ------------------------------------------------
                    // ACTIONS: Google Maps Navigation & Delete
                    // ------------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              GoogleMapsService.openPlaceInGoogleMaps(stop);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening Google Maps URL: ${googleData.googleMapsUrl}'),
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'Open',
                                    onPressed: () => GoogleMapsService.openPlaceInGoogleMaps(stop),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.map, size: 16),
                            label: const Text('View on Google Maps'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            final dirUrl = GoogleMapsService.getDirectionsToPlaceUrl(stop);
                            GoogleMapsService.openDirectionsToPlace(stop);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Navigating to ${stop.name} in Google Maps:\n$dirUrl'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.directions, size: 15, color: Color(0xFF2563EB)),
                          label: const Text('Directions', style: TextStyle(color: Color(0xFF2563EB))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFBFDBFE)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                        if (widget.onRemove != null) ...[
                          const SizedBox(width: 8),
                          IconButton.outlined(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onRemove!();
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: 'Remove stop from day',
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF475569)),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
