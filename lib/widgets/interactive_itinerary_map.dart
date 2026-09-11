import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/itinerary_trip_models.dart';
import '../services/google_maps_service.dart';
import '../theme.dart';

class InteractiveItineraryMap extends StatefulWidget {
  final List<ItineraryPlaceStop> stops;
  final String dayTitle;
  final int currentDayNumber;
  final Function(ItineraryPlaceStop stop)? onStopSelected;
  final VoidCallback? onToggleExpand;
  final bool isExpanded;

  const InteractiveItineraryMap({
    super.key,
    required this.stops,
    required this.dayTitle,
    required this.currentDayNumber,
    this.onStopSelected,
    this.onToggleExpand,
    this.isExpanded = false,
  });

  @override
  State<InteractiveItineraryMap> createState() => _InteractiveItineraryMapState();
}

class _InteractiveItineraryMapState extends State<InteractiveItineraryMap> {
  int? selectedStopIndex;
  double zoomLevel = 1.0;
  bool isSatellite = false;
  bool useGoogleStaticMap = true;

  @override
  void didUpdateWidget(covariant InteractiveItineraryMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentDayNumber != widget.currentDayNumber) {
      setState(() {
        selectedStopIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasStops = widget.stops.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isSatellite ? const Color(0xFF1E293B) : const Color(0xFFE8EEF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // --------------------------------------------------
          // MAP CANVAS (Google Maps Static API with Vector Fallback)
          // --------------------------------------------------
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth.toInt().clamp(300, 1024);
                final h = constraints.maxHeight.toInt().clamp(200, 768);

                if (useGoogleStaticMap && widget.stops.isNotEmpty) {
                  final staticMapUrl = GoogleMapsService.getStaticMapUrl(
                    stops: widget.stops,
                    mapType: isSatellite ? 'satellite' : 'roadmap',
                    width: w,
                    height: h,
                    selectedIndex: selectedStopIndex,
                  );

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        staticMapUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CustomPaint(
                            size: Size(constraints.maxWidth, constraints.maxHeight),
                            painter: _MapCanvasPainter(
                              stops: widget.stops,
                              selectedIndex: selectedStopIndex,
                              zoomLevel: zoomLevel,
                              isSatellite: isSatellite,
                            ),
                          );
                        },
                      ),
                      if (isSatellite)
                        Container(color: Colors.black.withValues(alpha: 0.15)),
                    ],
                  );
                }

                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _MapCanvasPainter(
                    stops: widget.stops,
                    selectedIndex: selectedStopIndex,
                    zoomLevel: zoomLevel,
                    isSatellite: isSatellite,
                  ),
                );
              },
            ),
          ),

          // --------------------------------------------------
          // INTERACTIVE STOP PINS ON CANVAS
          // --------------------------------------------------
          if (hasStops)
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final points = _calculateProjectedPoints(widget.stops, Size(constraints.maxWidth, constraints.maxHeight));
                  return Stack(
                    children: [
                      for (int i = 0; i < points.length; i++)
                        Positioned(
                          left: points[i].dx - 18,
                          top: points[i].dy - 36,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStopIndex = (selectedStopIndex == i) ? null : i;
                              });
                              if (widget.onStopSelected != null) {
                                widget.onStopSelected!(widget.stops[i]);
                              }
                            },
                            child: _buildPinMarker(i, widget.stops[i], selectedStopIndex == i),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

          // --------------------------------------------------
          // GOOGLE MAPS ATTRIBUTION BADGE
          // --------------------------------------------------
          Positioned(
            left: 14,
            bottom: (selectedStopIndex != null ? 150 : 54),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map, size: 11, color: Color(0xFFEA4335)),
                  SizedBox(width: 4),
                  Text(
                    'Google Maps Linked',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                  ),
                ],
              ),
            ),
          ),

          // --------------------------------------------------
          // TOP HEADER: Day Title & Quick Route Summary
          // --------------------------------------------------
          Positioned(
            top: 12,
            left: 14,
            right: 14,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined, size: 16, color: coral),
                      const SizedBox(width: 6),
                      Text(
                        'Day ${widget.currentDayNumber} Route Map',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.stops.length} Stops',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Google Directions button
                if (widget.stops.isNotEmpty) ...[
                  FilledButton.icon(
                    onPressed: () {
                      final dirUrl = GoogleMapsService.getFullDayDirectionsUrl(widget.stops);
                      GoogleMapsService.openFullDayRouteInGoogleMaps(widget.stops);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening Google Maps Directions for Day ${widget.currentDayNumber} (${widget.stops.length} stops):\n$dirUrl'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'Directions',
                            onPressed: () => GoogleMapsService.openFullDayRouteInGoogleMaps(widget.stops),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.directions, size: 13),
                    label: Text('Directions (${widget.stops.length})', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                // Satellite / Map Layer Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(isSatellite ? Icons.satellite_alt : Icons.map_outlined, size: 18, color: const Color(0xFF334155)),
                    tooltip: isSatellite ? 'Google Street Map' : 'Google Satellite View',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => isSatellite = !isSatellite),
                  ),
                ),
                if (widget.onToggleExpand != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(widget.isExpanded ? Icons.fullscreen_exit : Icons.fullscreen, size: 18, color: const Color(0xFF334155)),
                      tooltip: widget.isExpanded ? 'Collapse Map' : 'Expand Map',
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.onToggleExpand,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // --------------------------------------------------
          // BOTTOM FLOATING CARD: Selected Stop Info Callout
          // --------------------------------------------------
          if (selectedStopIndex != null && selectedStopIndex! < widget.stops.length)
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: _buildSelectedStopPopover(widget.stops[selectedStopIndex!], selectedStopIndex! + 1),
            )
          else if (hasStops)
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: _buildRouteSummaryBar(),
            ),

          // --------------------------------------------------
          // ZOOM CONTROLS (Right Side)
          // --------------------------------------------------
          Positioned(
            right: 14,
            bottom: selectedStopIndex != null ? 140 : 54,
            child: Column(
              children: [
                _buildMapControlBtn(
                  icon: Icons.add,
                  tooltip: 'Zoom In',
                  onTap: () => setState(() => zoomLevel = (zoomLevel + 0.2).clamp(0.8, 2.0)),
                ),
                const SizedBox(height: 6),
                _buildMapControlBtn(
                  icon: Icons.remove,
                  tooltip: 'Zoom Out',
                  onTap: () => setState(() => zoomLevel = (zoomLevel - 0.2).clamp(0.8, 2.0)),
                ),
                const SizedBox(height: 6),
                _buildMapControlBtn(
                  icon: Icons.my_location,
                  tooltip: 'Center Day Route',
                  onTap: () => setState(() {
                    zoomLevel = 1.0;
                    selectedStopIndex = null;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlBtn({required IconData icon, required String tooltip, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(icon, size: 16, color: const Color(0xFF1E293B)),
        ),
      ),
    );
  }

  Widget _buildPinMarker(int index, ItineraryPlaceStop stop, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0F172A) : coral,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? Colors.black : coral).withValues(alpha: 0.4),
                  blurRadius: isSelected ? 10 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  Text(
                    stop.categoryIcon,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
          CustomPaint(
            size: const Size(10, 6),
            painter: _PinArrowPainter(color: isSelected ? const Color(0xFF0F172A) : coral),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedStopPopover(ItineraryPlaceStop stop, int stepNumber) {
    final googleData = GoogleMapsService.getPlaceDetails(stop);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: coral.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: coral,
                child: Text(
                  '$stepNumber',
                  style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stop.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(() => selectedStopIndex = null),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${stop.categoryIcon} ${stop.category}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              const Icon(Icons.star, size: 13, color: Color(0xFFF59E0B)),
              const SizedBox(width: 2),
              Text('${googleData.rating} (${googleData.userRatingsTotal} Google reviews)', style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            googleData.formattedAddress,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '⏱ ${stop.duration} · 💰 ${stop.estimatedCost}',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.directions, size: 16, color: Color(0xFF2563EB)),
                    tooltip: 'Google Maps Directions',
                    visualDensity: VisualDensity.compact,
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
                  ),
                  const SizedBox(width: 2),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      GoogleMapsService.openPlaceInGoogleMaps(stop);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening Google Maps URL: ${googleData.googleMapsUrl}'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new, size: 12),
                    label: const Text('View Google Maps', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      backgroundColor: const Color(0xFFEFF6FF),
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSummaryBar() {
    final routeSteps = widget.stops.asMap().entries.map((e) => '${e.key + 1}. ${e.value.name.split(' ').first}').join('  ➔  ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.route, size: 15, color: coral),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              routeSteps,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Tap pin for details',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  List<Offset> _calculateProjectedPoints(List<ItineraryPlaceStop> stops, Size size) {
    if (stops.isEmpty) return [];
    if (stops.length == 1) {
      return [Offset(size.width * 0.5, size.height * 0.5)];
    }

    double minLat = stops.first.lat;
    double maxLat = stops.first.lat;
    double minLng = stops.first.lng;
    double maxLng = stops.first.lng;

    for (final s in stops) {
      if (s.lat < minLat) minLat = s.lat;
      if (s.lat > maxLat) maxLat = s.lat;
      if (s.lng < minLng) minLng = s.lng;
      if (s.lng > maxLng) maxLng = s.lng;
    }

    final latRange = (maxLat - minLat == 0) ? 0.01 : (maxLat - minLat);
    final lngRange = (maxLng - minLng == 0) ? 0.01 : (maxLng - minLng);

    // Padding inside map
    const paddingX = 48.0;
    const paddingTop = 70.0;
    const paddingBottom = 60.0;
    final usableW = size.width - (paddingX * 2);
    final usableH = size.height - (paddingTop + paddingBottom);

    return stops.map((s) {
      final normX = (s.lng - minLng) / lngRange;
      final normY = 1.0 - ((s.lat - minLat) / latRange); // Invert Y since screen coordinates go down

      final centerX = size.width * 0.5;
      final centerY = size.height * 0.5;

      final rawX = paddingX + normX * usableW;
      final rawY = paddingTop + normY * usableH;

      final zoomedX = centerX + (rawX - centerX) * zoomLevel;
      final zoomedY = centerY + (rawY - centerY) * zoomLevel;

      return Offset(zoomedX, zoomedY);
    }).toList();
  }
}

class _PinArrowPainter extends CustomPainter {
  final Color color;
  _PinArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.5, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinArrowPainter oldDelegate) => oldDelegate.color != color;
}

class _MapCanvasPainter extends CustomPainter {
  final List<ItineraryPlaceStop> stops;
  final int? selectedIndex;
  final double zoomLevel;
  final bool isSatellite;

  _MapCanvasPainter({
    required this.stops,
    required this.selectedIndex,
    required this.zoomLevel,
    required this.isSatellite,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw stylized terrain / street background
    final bgPaint = Paint()
      ..color = isSatellite ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Draw styled stylized park and water bodies
    final waterPaint = Paint()
      ..color = isSatellite ? const Color(0xFF0F172A) : const Color(0xFFCCE5FF)
      ..style = PaintingStyle.fill;

    // Curved bay / river representation
    final riverPath = Path()
      ..moveTo(size.width * 0.82, 0)
      ..cubicTo(size.width * 0.78, size.height * 0.4, size.width * 0.9, size.height * 0.7, size.width, size.height * 0.85)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(riverPath, waterPaint);

    // Park area representation
    final parkPaint = Paint()
      ..color = isSatellite ? const Color(0xFF14532D).withValues(alpha: 0.3) : const Color(0xFFDCFCE7)
      ..style = PaintingStyle.fill;
    final parkRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.35, size.width * 0.24, size.height * 0.3),
      const Radius.circular(16),
    );
    canvas.drawRRect(parkRect, parkPaint);

    // 3. Draw grid street lines
    final streetPaint = Paint()
      ..color = isSatellite ? Colors.white10 : const Color(0xFFE2E8F0)
      ..strokeWidth = 2.0;

    for (double y = 40; y < size.height; y += 45) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }
    for (double x = 30; x < size.width; x += 55) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }

    if (stops.length < 2) return;

    // 4. Calculate point coordinates
    final points = _calculatePoints(stops, size);

    // 5. Draw connecting polyline route with glowing shadow
    final routeShadowPaint = Paint()
      ..color = coral.withValues(alpha: 0.3)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final routeLinePaint = Paint()
      ..color = coral
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final routePath = Path();
    routePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      routePath.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(routePath, routeShadowPaint);
    canvas.drawPath(routePath, routeLinePaint);

    // 6. Draw distance badge dots halfway along each route segment
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final mid = Offset((p1.dx + p2.dx) * 0.5, (p1.dy + p2.dy) * 0.5);

      final dotBg = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final dotBorder = Paint()
        ..color = coral
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(mid, 7, dotBg);
      canvas.drawCircle(mid, 7, dotBorder);

      // Arrow in direction of route
      final angle = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);
      canvas.save();
      canvas.translate(mid.dx, mid.dy);
      canvas.rotate(angle);
      final arrowPath = Path()
        ..moveTo(-3, -3)
        ..lineTo(3, 0)
        ..lineTo(-3, 3);
      canvas.drawPath(arrowPath, dotBorder);
      canvas.restore();
    }
  }

  List<Offset> _calculatePoints(List<ItineraryPlaceStop> stops, Size size) {
    double minLat = stops.first.lat;
    double maxLat = stops.first.lat;
    double minLng = stops.first.lng;
    double maxLng = stops.first.lng;

    for (final s in stops) {
      if (s.lat < minLat) minLat = s.lat;
      if (s.lat > maxLat) maxLat = s.lat;
      if (s.lng < minLng) minLng = s.lng;
      if (s.lng > maxLng) maxLng = s.lng;
    }

    final latRange = (maxLat - minLat == 0) ? 0.01 : (maxLat - minLat);
    final lngRange = (maxLng - minLng == 0) ? 0.01 : (maxLng - minLng);

    const paddingX = 48.0;
    const paddingTop = 70.0;
    const paddingBottom = 60.0;
    final usableW = size.width - (paddingX * 2);
    final usableH = size.height - (paddingTop + paddingBottom);

    return stops.map((s) {
      final normX = (s.lng - minLng) / lngRange;
      final normY = 1.0 - ((s.lat - minLat) / latRange);

      final centerX = size.width * 0.5;
      final centerY = size.height * 0.5;

      final rawX = paddingX + normX * usableW;
      final rawY = paddingTop + normY * usableH;

      final zoomedX = centerX + (rawX - centerX) * zoomLevel;
      final zoomedY = centerY + (rawY - centerY) * zoomLevel;

      return Offset(zoomedX, zoomedY);
    }).toList();
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.stops != stops ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.isSatellite != isSatellite;
  }
}
