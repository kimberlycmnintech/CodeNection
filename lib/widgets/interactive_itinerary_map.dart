import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';
import '../services/google_maps_service.dart';
import '../theme.dart';

class InteractiveItineraryMap extends StatefulWidget {
  final List<ItineraryPlaceStop> stops;
  final String dayTitle;
  final int currentDayNumber;
  final List<ItineraryDayData>? allDays;
  final int? activeDayIndex;
  final Function(int dayIndex)? onDaySelected;
  final Function(ItineraryPlaceStop stop)? onStopSelected;
  final VoidCallback? onToggleExpand;
  final bool isExpanded;
  final bool showHeaderOverlay;
  final bool showPath;
  final int? selectedStopIndex;
  final ValueChanged<int?>? onSelectedStopIndexChanged;

  const InteractiveItineraryMap({
    super.key,
    required this.stops,
    required this.dayTitle,
    required this.currentDayNumber,
    this.allDays,
    this.activeDayIndex,
    this.onDaySelected,
    this.onStopSelected,
    this.onToggleExpand,
    this.isExpanded = false,
    this.showHeaderOverlay = true,
    this.showPath = true,
    this.selectedStopIndex,
    this.onSelectedStopIndexChanged,
  });

  @override
  State<InteractiveItineraryMap> createState() => _InteractiveItineraryMapState();
}

class _InteractiveItineraryMapState extends State<InteractiveItineraryMap> {
  int? _internalSelectedStopIndex;
  int? get effectiveSelectedStopIndex => widget.selectedStopIndex ?? _internalSelectedStopIndex;

  double zoomLevel = 1.0;
  double _currentScale = 1.0;
  bool isSatellite = false;
  bool useGoogleStaticMap = true;
  bool showAllDaysOverview = false;
  int _activeDetailTab = 0; // 0: About, 1: Reviews, 2: Photos

  late final TransformationController _mapTransformationController;

  @override
  void initState() {
    super.initState();
    _mapTransformationController = TransformationController();
    _mapTransformationController.addListener(_onMapTransformChanged);
    _internalSelectedStopIndex = widget.selectedStopIndex;
  }

  void _onMapTransformChanged() {
    final scale = _mapTransformationController.value.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() > 0.02) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  @override
  void dispose() {
    _mapTransformationController.removeListener(_onMapTransformChanged);
    _mapTransformationController.dispose();
    super.dispose();
  }

  void _handleZoomIn() {
    final currentScale = _mapTransformationController.value.getMaxScaleOnAxis();
    if (currentScale >= 3.45) return;
    final targetScale = (currentScale * 1.25).clamp(1.0, 3.5);
    final factor = targetScale / currentScale;
    _mapTransformationController.value = _mapTransformationController.value.scaledByDouble(factor, factor, 1.0, 1.0);
  }

  void _handleZoomOut() {
    final currentScale = _mapTransformationController.value.getMaxScaleOnAxis();
    if (currentScale <= 1.05) {
      _mapTransformationController.value = Matrix4.identity();
      return;
    }
    final targetScale = (currentScale / 1.25).clamp(1.0, 3.5);
    final factor = targetScale / currentScale;
    _mapTransformationController.value = _mapTransformationController.value.scaledByDouble(factor, factor, 1.0, 1.0);
  }

  void _handleCenterMap() {
    _mapTransformationController.value = Matrix4.identity();
  }

  @override
  void didUpdateWidget(covariant InteractiveItineraryMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentDayNumber != widget.currentDayNumber) {
      setState(() {
        _internalSelectedStopIndex = null;
      });
      _mapTransformationController.value = Matrix4.identity();
    }
    if (widget.selectedStopIndex != oldWidget.selectedStopIndex) {
      setState(() {
        _internalSelectedStopIndex = widget.selectedStopIndex;
      });
    }
  }

  void _updateSelectedStopIndex(int? index) {
    setState(() {
      _internalSelectedStopIndex = index;
    });
    widget.onSelectedStopIndexChanged?.call(index);
    if (index != null && index >= 0 && index < widget.stops.length) {
      widget.onStopSelected?.call(widget.stops[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasStops = widget.stops.isNotEmpty;
    final dayColor = DayColorPalette.getColorForDay(widget.currentDayNumber);

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
          // MAP CANVAS (Interactive Drag & Zoom with InteractiveViewer)
          // Always full-bleed (minScale: 1.0) so map never shrinks into a floating card
          // --------------------------------------------------
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _mapTransformationController,
              panEnabled: true,
              scaleEnabled: true,
              minScale: 1.0,
              maxScale: 3.5,
              boundaryMargin: EdgeInsets.zero,
              clipBehavior: Clip.none,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth.toInt().clamp(300, 1024);
                  final h = constraints.maxHeight.toInt().clamp(200, 768);

                  final effectiveActiveDayIndex = showAllDaysOverview
                      ? null
                      : (widget.activeDayIndex ?? (widget.currentDayNumber - 1));

                  // When zoomed in, request smaller Google Static Maps markers so baked markers don't enlarge
                  final dynamicMarkerSize = _currentScale > 1.6
                      ? 'tiny'
                      : (_currentScale > 1.25 ? 'small' : (_currentScale > 1.05 ? 'mid' : null));

                  final staticMapUrl = GoogleMapsService.getStaticMapUrl(
                    stops: widget.stops,
                    allDays: widget.allDays,
                    activeDayIndex: effectiveActiveDayIndex,
                    mapType: isSatellite ? 'satellite' : 'roadmap',
                    width: w,
                    height: h,
                    selectedIndex: effectiveSelectedStopIndex,
                    showPath: widget.showPath,
                    markerSize: dynamicMarkerSize,
                  );

                  // Calculate counter-scale so pins get smaller as zoom increases:
                  // When _currentScale = 1.0 -> 1.0
                  // When _currentScale = 2.0 -> 0.58
                  // When _currentScale = 3.0 -> 0.43
                  final labelScale = (1.0 / math.pow(_currentScale, 0.78)).clamp(0.38, 1.0);
                  final points = hasStops ? _calculateProjectedPoints(widget.stops, Size(constraints.maxWidth, constraints.maxHeight)) : <Offset>[];

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // 1. Base Map Layer (Google Static Map or Vector Canvas)
                      if (useGoogleStaticMap && (widget.stops.isNotEmpty || (widget.allDays != null && widget.allDays!.isNotEmpty))) ...[
                        Image.network(
                          staticMapUrl,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CustomPaint(
                              size: Size(constraints.maxWidth, constraints.maxHeight),
                              painter: _MapCanvasPainter(
                                stops: widget.stops,
                                allDays: widget.allDays,
                                dayNumber: widget.currentDayNumber,
                                activeDayIndex: effectiveActiveDayIndex,
                                dayColor: dayColor,
                                selectedIndex: effectiveSelectedStopIndex,
                                zoomLevel: zoomLevel,
                                isSatellite: isSatellite,
                                showPath: widget.showPath,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return CustomPaint(
                              size: Size(constraints.maxWidth, constraints.maxHeight),
                              painter: _MapCanvasPainter(
                                stops: widget.stops,
                                allDays: widget.allDays,
                                dayNumber: widget.currentDayNumber,
                                activeDayIndex: effectiveActiveDayIndex,
                                dayColor: dayColor,
                                selectedIndex: effectiveSelectedStopIndex,
                                zoomLevel: zoomLevel,
                                isSatellite: isSatellite,
                                showPath: widget.showPath,
                              ),
                            );
                          },
                        ),
                        if (isSatellite)
                          Container(color: Colors.black.withValues(alpha: 0.15)),
                      ] else ...[
                        CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxHeight),
                          painter: _MapCanvasPainter(
                            stops: widget.stops,
                            allDays: widget.allDays,
                            dayNumber: widget.currentDayNumber,
                            activeDayIndex: showAllDaysOverview ? null : (widget.activeDayIndex ?? (widget.currentDayNumber - 1)),
                            dayColor: dayColor,
                            selectedIndex: effectiveSelectedStopIndex,
                            zoomLevel: zoomLevel,
                            isSatellite: isSatellite,
                            showPath: widget.showPath,
                          ),
                        ),
                      ],

                      // 2. Interactive Stop Pins & Location Bubbles with Zoom-adaptive Sizing
                      if (hasStops)
                        for (int i = 0; i < points.length; i++)
                          Positioned(
                            left: points[i].dx - (20 * labelScale),
                            top: points[i].dy - (effectiveSelectedStopIndex == i ? (58 * labelScale) : (38 * labelScale)),
                            child: GestureDetector(
                              onTap: () {
                                _updateSelectedStopIndex((effectiveSelectedStopIndex == i) ? null : i);
                              },
                              child: _buildPinMarker(
                                i,
                                widget.stops[i],
                                effectiveSelectedStopIndex == i,
                                dayColor,
                                labelScale,
                                _currentScale,
                              ),
                            ),
                          ),
                    ],
                  );
                },
              ),
            ),
          ),

          // --------------------------------------------------
          // BOTTOM FLOATING STOP CHIPS (When Google Static Map is active)
          // --------------------------------------------------
          if (useGoogleStaticMap && hasStops && effectiveSelectedStopIndex == null)
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < widget.stops.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: InkWell(
                          onTap: () => _updateSelectedStopIndex(i),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: dayColor.withValues(alpha: 0.5),
                                width: 1.2,
                              ),
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
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: dayColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 130),
                                  child: Text(
                                    'Stop ${i + 1}: ${widget.stops[i].name.split(' ').take(2).join(' ')}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // --------------------------------------------------
          // GOOGLE MAPS ATTRIBUTION BADGE
          // --------------------------------------------------
          Positioned(
            left: 12,
            bottom: (effectiveSelectedStopIndex != null ? 275 : 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                        TextSpan(text: 'o', style: TextStyle(color: Color(0xFFEA4335))),
                        TextSpan(text: 'o', style: TextStyle(color: Color(0xFFFBBC05))),
                        TextSpan(text: 'g', style: TextStyle(color: Color(0xFF4285F4))),
                        TextSpan(text: 'l', style: TextStyle(color: Color(0xFF34A853))),
                        TextSpan(text: 'e', style: TextStyle(color: Color(0xFFEA4335))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Map data ©2026 TMap Mobility',
                    style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ),

          // --------------------------------------------------
          // TOP HEADER: Day Title & Quick Route Summary
          // --------------------------------------------------
          if (widget.showHeaderOverlay)
            Positioned(
              top: 12,
              left: 14,
              right: 14,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(width: 12),
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
            ),

          // --------------------------------------------------
          // BOTTOM FLOATING CARD: Selected Stop Info Callout
          // --------------------------------------------------
          // --------------------------------------------------
          // BOTTOM FLOATING CARD: Selected Stop Info Callout (Picture 2 overlay)
          // --------------------------------------------------
          if (effectiveSelectedStopIndex != null && effectiveSelectedStopIndex! < widget.stops.length)
            Positioned(
              left: 12,
              right: 12,
              bottom: 8,
              child: _buildSelectedStopBottomOverlayCard(
                widget.stops[effectiveSelectedStopIndex!],
                effectiveSelectedStopIndex! + 1,
              ),
            ),

          // FLOATING AI ACTION BUTTON (Picture 2 bottom right)
          if (effectiveSelectedStopIndex != null)
            Positioned(
              right: 18,
              bottom: 275,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE11D48), Color(0xFF8B5CF6)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              ),
            ),

          // --------------------------------------------------
          // ZOOM CONTROLS (Upper Right Side)
          // --------------------------------------------------
          Positioned(
            right: 14,
            top: 56,
            child: Column(
              children: [
                _buildMapControlBtn(
                  icon: Icons.add,
                  tooltip: 'Zoom In',
                  onTap: _handleZoomIn,
                ),
                const SizedBox(height: 6),
                _buildMapControlBtn(
                  icon: Icons.remove,
                  tooltip: 'Zoom Out',
                  onTap: _handleZoomOut,
                ),
                const SizedBox(height: 6),
                _buildMapControlBtn(
                  icon: Icons.my_location,
                  tooltip: 'Center Day Route',
                  onTap: _handleCenterMap,
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

  Widget _buildPinMarker(
    int index,
    ItineraryPlaceStop stop,
    bool isSelected, [
    Color pinColor = coral,
    double scale = 1.0,
    double zoom = 1.0,
  ]) {
    final effectiveColor = isSelected ? const Color(0xFF0F172A) : pinColor;
    // When zooming in, font size and padding dynamically scale down so labels don't cover locations:
    final fontSize = (10.5 / math.sqrt(zoom)).clamp(7.0, 10.5);
    final padH = (7.0 * scale).clamp(3.5, 7.0);
    final padV = (3.5 * scale).clamp(2.0, 3.5);

    return Transform.scale(
      scale: scale * (isSelected ? 1.15 : 1.0),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // If selected, show compact location bubble on the map
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(bottom: 3),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: effectiveColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: effectiveColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    stop.name.split(' ').take(3).join(' '),
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 9.5, color: Color(0xFFF59E0B)),
                  Text(
                    '${stop.rating}',
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
            ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
            decoration: BoxDecoration(
              color: effectiveColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: (2.0 * scale).clamp(1.2, 2.0)),
              boxShadow: [
                BoxShadow(
                  color: effectiveColor.withValues(alpha: 0.4),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: fontSize,
                  ),
                ),
                if (isSelected && zoom < 1.6) ...[
                  const SizedBox(width: 3),
                  Text(
                    stop.categoryIcon,
                    style: TextStyle(fontSize: (9.5 * scale).clamp(6.5, 9.5)),
                  ),
                ],
              ],
            ),
          ),
          CustomPaint(
            size: Size(9 * scale, 5 * scale),
            painter: _PinArrowPainter(color: effectiveColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedStopBottomOverlayCard(ItineraryPlaceStop stop, int stepNumber) {
    final googleData = GoogleMapsService.getPlaceDetails(stop);
    final dayColor = DayColorPalette.getColorForDay(widget.currentDayNumber);
    final photoUrl = stop.imageUrl ??
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500';

    return Container(
      constraints: const BoxConstraints(maxHeight: 265),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. TOP PAGER & TOOLBAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                // Pager: < X of Y >
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: (effectiveSelectedStopIndex != null && effectiveSelectedStopIndex! > 0)
                            ? () => _updateSelectedStopIndex(effectiveSelectedStopIndex! - 1)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Icon(
                            Icons.chevron_left,
                            size: 16,
                            color: (effectiveSelectedStopIndex != null && effectiveSelectedStopIndex! > 0)
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                      Text(
                        '$stepNumber of ${widget.stops.length}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      InkWell(
                        onTap: (effectiveSelectedStopIndex != null && effectiveSelectedStopIndex! < widget.stops.length - 1)
                            ? () => _updateSelectedStopIndex(effectiveSelectedStopIndex! + 1)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: (effectiveSelectedStopIndex != null && effectiveSelectedStopIndex! < widget.stops.length - 1)
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Search / Inspect Icon
                InkWell(
                  onTap: () {
                    setState(() {
                      zoomLevel = 1.3;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: const Icon(Icons.search, size: 15, color: Color(0xFF475569)),
                  ),
                ),
                const SizedBox(width: 8),

                // Optimize route PRO chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.alt_route, size: 12, color: Color(0xFFB45309)),
                      const SizedBox(width: 3),
                      Text(
                        'Optimize route',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Close Button X
                IconButton(
                  icon: const Icon(Icons.close, size: 17, color: Color(0xFF64748B)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  tooltip: 'Close place details',
                  onPressed: () => _updateSelectedStopIndex(null),
                ),
              ],
            ),
          ),

          // 2. TABS BAR: About | Reviews | Photos
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                _buildOverlayTab('About', 0),
                const SizedBox(width: 12),
                _buildOverlayTab('Reviews', 1),
                const SizedBox(width: 12),
                _buildOverlayTab('Photos', 2),
              ],
            ),
          ),

          // 3. SINGLE-GLANCE CONTENT (Compact layout, smaller fonts)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Number badge + Stop Name + Rating/Category + Thumbnail
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 11,
                        backgroundColor: dayColor,
                        child: Text(
                          '$stepNumber',
                          style: const TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    stop.category,
                                    style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w600, color: const Color(0xFF475569)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.star, size: 11.5, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 2),
                                Text(
                                  '${googleData.rating} (${googleData.userRatingsTotal})',
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEA4335).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text('G', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Color(0xFFEA4335))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          photoUrl,
                          width: 52,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 52,
                            height: 44,
                            color: const Color(0xFFE2E8F0),
                            child: const Icon(Icons.image, size: 16, color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Row 2: Action tags: [ ✓ Added ] [ ✓ Mark as visited ] [ Ask AI ]
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check, size: 11, color: Color(0xFF475569)),
                              const SizedBox(width: 3),
                              Text(
                                'Added',
                                style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF475569)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Marked "${stop.name}" as visited!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check, size: 11, color: Color(0xFF2563EB)),
                                const SizedBox(width: 3),
                                Text(
                                  'Mark as visited',
                                  style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF2563EB)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.auto_awesome, size: 10, color: Colors.white),
                              SizedBox(width: 3),
                              Text('Ask AI', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        _buildPromptSuggestionChip('Vegetarian options?'),
                        const SizedBox(width: 5),
                        _buildPromptSuggestionChip('Price range?'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Row 3: Address & Hours
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 11.5, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          googleData.formattedAddress,
                          style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time, size: 11.5, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        googleData.weekdayHours.isNotEmpty ? googleData.weekdayHours.first.split(': ').last : '8:00 AM – 8:00 PM',
                        style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Row 4: WHY TRIPNEST RECOMMENDS IT & About this place
                  Text(
                    'WHY TRIPNEST RECOMMENDS IT',
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF2563EB),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    stop.whyRecommended,
                    style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF334155), height: 1.25),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  Text(
                    'About this place',
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    stop.description,
                    style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B), height: 1.25),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Row 5: Action Buttons (View on Google Maps, Directions)
                  Row(
                    children: [
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
                        label: const Text('View on Google Maps', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: const Color(0xFFEFF6FF),
                          foregroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          GoogleMapsService.openDirectionsToPlace(stop);
                        },
                        icon: const Icon(Icons.navigation_outlined, size: 12),
                        label: const Text('Directions', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayTab(String label, int index) {
    final isSelected = _activeDetailTab == index;
    return InkWell(
      onTap: () => setState(() => _activeDetailTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFE11D48) : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? const Color(0xFFE11D48) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildPromptSuggestionChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF334155), fontWeight: FontWeight.w500),
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
  final List<ItineraryDayData>? allDays;
  final int dayNumber;
  final int? activeDayIndex;
  final Color dayColor;
  final int? selectedIndex;
  final double zoomLevel;
  final bool isSatellite;
  final bool showPath;

  _MapCanvasPainter({
    required this.stops,
    this.allDays,
    required this.dayNumber,
    this.activeDayIndex,
    required this.dayColor,
    required this.selectedIndex,
    required this.zoomLevel,
    required this.isSatellite,
    this.showPath = true,
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

    if (stops.isEmpty && (allDays == null || allDays!.isEmpty)) return;

    // 4. Calculate realistic street route coordinates for active day
    final routeCoords = GoogleMapsService.getRealisticRoutePoints(stops, dayNumber);
    final routePoints = _calculateCustomPoints(routeCoords, stops, size);
    final stopPoints = _calculatePoints(stops, size);

    // 5. Draw connecting polyline route with active day color
    if (showPath && activeDayIndex != null && routePoints.length > 1) {
      final routeShadowPaint = Paint()
        ..color = dayColor.withValues(alpha: 0.35)
        ..strokeWidth = 7.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final routeLinePaint = Paint()
        ..color = dayColor
        ..strokeWidth = 3.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final routePath = Path();
      routePath.moveTo(routePoints.first.dx, routePoints.first.dy);
      for (int i = 1; i < routePoints.length; i++) {
        routePath.lineTo(routePoints[i].dx, routePoints[i].dy);
      }

      canvas.drawPath(routePath, routeShadowPaint);
      canvas.drawPath(routePath, routeLinePaint);

      // Distance badge dots halfway along each stop-to-stop segment
      for (int i = 0; i < stopPoints.length - 1; i++) {
        final p1 = stopPoints[i];
        final p2 = stopPoints[i + 1];
        final mid = Offset((p1.dx + p2.dx) * 0.5, (p1.dy + p2.dy) * 0.5);

        final dotBg = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        final dotBorder = Paint()
          ..color = dayColor
          ..strokeWidth = 1.6
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

    // 6. Draw stops pins on vector canvas
    for (int i = 0; i < stopPoints.length; i++) {
      final pt = stopPoints[i];
      final isSelected = selectedIndex != null && selectedIndex == i;
      final pinBg = Paint()
        ..color = isSelected ? const Color(0xFF0F172A) : dayColor
        ..style = PaintingStyle.fill;
      final pinBorder = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(pt, isSelected ? 14 : 11, pinBg);
      canvas.drawCircle(pt, isSelected ? 14 : 11, pinBorder);

      final textSpan = TextSpan(
        text: '${i + 1}',
        style: TextStyle(
          color: Colors.white,
          fontSize: isSelected ? 11 : 9.5,
          fontWeight: FontWeight.w900,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(pt.dx - textPainter.width / 2, pt.dy - textPainter.height / 2),
      );
    }
  }

  List<Offset> _calculateCustomPoints(
    List<Map<String, double>> coords,
    List<ItineraryPlaceStop> boundingStops,
    Size size,
  ) {
    if (coords.isEmpty || boundingStops.isEmpty) return [];

    double minLat = boundingStops.first.lat;
    double maxLat = boundingStops.first.lat;
    double minLng = boundingStops.first.lng;
    double maxLng = boundingStops.first.lng;

    for (final s in boundingStops) {
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

    return coords.map((pt) {
      final lat = pt['lat']!;
      final lng = pt['lng']!;
      final normX = (lng - minLng) / lngRange;
      final normY = 1.0 - ((lat - minLat) / latRange);

      final centerX = size.width * 0.5;
      final centerY = size.height * 0.5;

      final rawX = paddingX + normX * usableW;
      final rawY = paddingTop + normY * usableH;

      final zoomedX = centerX + (rawX - centerX) * zoomLevel;
      final zoomedY = centerY + (rawY - centerY) * zoomLevel;

      return Offset(zoomedX, zoomedY);
    }).toList();
  }

  List<Offset> _calculatePoints(List<ItineraryPlaceStop> stops, Size size) {
    if (stops.isEmpty) return [];
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
        oldDelegate.allDays != allDays ||
        oldDelegate.dayNumber != dayNumber ||
        oldDelegate.activeDayIndex != activeDayIndex ||
        oldDelegate.dayColor != dayColor ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.isSatellite != isSatellite ||
        oldDelegate.showPath != showPath;
  }
}
