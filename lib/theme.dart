import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// =====================================================================
// TRIPNEST EDITORIAL DESIGN SYSTEM
// Soft futuristic travel-tech — pastel gradients, serif display type,
// frosted surfaces, generous white space, dreamy & aspirational.
// =====================================================================

// --- Core palette ----------------------------------------------------
const tnSky       = Color(0xFFDEEEF8);   // Pale sky blue (card tint, bg)
const tnMint      = Color(0xFFDDF0EA);   // Soft mint (accent surface)
const tnCream     = Color(0xFFFDF6EE);   // Warm cream (bg warm tint)
const tnLavender  = Color(0xFFEDE8F8);   // Subtle lavender (hero gradient)
const tnBlush     = Color(0xFFFDE8E8);   // Light blush (highlight)

const tnDark      = Color(0xFF18181B);   // Near-black (headlines, CTAs)
const tnCharcoal  = Color(0xFF3F3F46);   // Dark charcoal (sub-headings)
const tnMuted     = Color(0xFF8B8B98);   // Muted gray (secondary text)
const tnHair      = Color(0xFFE8E8F0);   // Hairline border / divider
const tnCard      = Color(0xFFFFFFFF);   // Pure white card surface

// Accent
const tnBlue      = Color(0xFF3B8EEA);   // Sky blue accent (links, badges)
const tnGreen     = Color(0xFF34C77B);   // Mint green (verified, success)
const tnAmber     = Color(0xFFF5A623);   // Warm amber (ratings)
const tnRed       = Color(0xFFFF5A5A);   // Soft coral-red (heart, error)

// Gradient stops (use in Container decorations)
const List<Color> bgGradientColors = [
  Color(0xFFE8F4FD), // top: pale sky
  Color(0xFFF2EEF8), // mid: soft lavender
  Color(0xFFFDF6EE), // bottom: warm cream
];

const List<Color> heroGradientColors = [
  Color(0xFFD5EBF9),
  Color(0xFFEAE2F8),
];

// --- Legacy aliases (keep existing code working) ---------------------
const primaryColor = tnDark;
const coral        = Color(0xFFFF6B6B);
const iceBg        = Color(0xFFEDF5FB);
const mintBg       = Color(0xFFF0FAF6);
const darkSlate    = tnDark;
const azureBlue    = tnBlue;
const skyAccent    = Color(0xFF38BDF8);
const lightAzure   = Color(0xFFE0F2FE);

// Tripzen tokens (aliases for backward compat)
const tripzenBg     = Color(0xFFF4F7FC);
const tripzenCard   = tnCard;
const tripzenDark   = tnDark;
const tripzenGray   = tnMuted;
const tripzenBorder = tnHair;
const tripzenBlue   = tnBlue;
const tripzenRed    = tnRed;
const tripzenAmber  = tnAmber;
const tripzenGreen  = tnGreen;

// =====================================================================
// TYPOGRAPHY
// Playfair Display for editorial display — Inter for UI / body
// =====================================================================

/// Large editorial display (serif) — hero headlines, section titles
TextStyle tnDisplay(double size, {Color? color, bool italic = false}) =>
    GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: FontWeight.w700,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      color: color ?? tnDark,
      letterSpacing: -0.3,
      height: 1.15,
    );

/// Medium heading — section labels, card titles (Inter bold)
TextStyle tnHead(double size, {Color? color, FontWeight? weight}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight ?? FontWeight.w700,
      color: color ?? tnDark,
      letterSpacing: -0.2,
    );

/// Body text — descriptions, meta info (Inter)
TextStyle tnBody(double size, {Color? color, FontWeight? weight}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight ?? FontWeight.w400,
      color: color ?? tnMuted,
    );

/// Label / button / pill text (Inter semibold)
TextStyle tnLabel(double size, {Color? color, FontWeight? weight}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight ?? FontWeight.w600,
      color: color ?? tnDark,
      letterSpacing: 0.1,
    );

// --- Legacy helpers (now map to new system) --------------------------
TextStyle boldItalicTitle(double size, {Color? color, double? height}) =>
    GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: color ?? tnDark,
      height: height,
      letterSpacing: -0.3,
    );

TextStyle boldTitle(double size, {Color? color}) =>
    GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color ?? tnDark,
    );

TextStyle bodyFont(double size, {Color? color, FontWeight? weight}) =>
    GoogleFonts.inter(
      fontSize: size,
      color: color ?? tnMuted,
      fontWeight: weight ?? FontWeight.w400,
    );

// New aliased helpers for Tripzen compat
TextStyle tzDisplay(double size, {Color? color, FontWeight? weight}) =>
    tnDisplay(size, color: color);

TextStyle tzHeading(double size, {Color? color, FontWeight? weight}) =>
    tnHead(size, color: color, weight: weight);

TextStyle tzBody(double size, {Color? color, FontWeight? weight}) =>
    tnBody(size, color: color, weight: weight);

TextStyle tzLabel(double size, {Color? color, FontWeight? weight}) =>
    tnLabel(size, color: color, weight: weight);

// =====================================================================
// SHARED DECORATIONS
// =====================================================================

/// Soft editorial card — white, large radius, gentle shadow
BoxDecoration tnCardDecor({double radius = 24, Color? color, List<Color>? gradient}) =>
    BoxDecoration(
      color: gradient == null ? (color ?? tnCard) : null,
      gradient: gradient != null
          ? LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF18181B).withValues(alpha: 0.06),
          blurRadius: 20,
          offset: const Offset(0, 6),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: const Color(0xFF18181B).withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );

/// Frosted / translucent surface
BoxDecoration tnFrosted({double radius = 20, Color? tint}) => BoxDecoration(
  color: (tint ?? Colors.white).withValues(alpha: 0.72),
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(
    color: Colors.white.withValues(alpha: 0.6),
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF3B8EEA).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ],
);

/// Dark primary CTA button
BoxDecoration tnDarkCta({double radius = 100}) => BoxDecoration(
  color: tnDark,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: [
    BoxShadow(
      color: tnDark.withValues(alpha: 0.22),
      blurRadius: 16,
      offset: const Offset(0, 6),
      spreadRadius: -2,
    ),
  ],
);

/// Soft pill (light bg, subtle border)
BoxDecoration tnPill({Color? bg, Color? border}) => BoxDecoration(
  color: bg ?? Colors.white,
  borderRadius: BorderRadius.circular(100),
  border: Border.all(color: border ?? tnHair, width: 1),
);

// Legacy compat
BoxDecoration tzCard({double radius = 20, Color? color}) => tnCardDecor(radius: radius, color: color);
BoxDecoration tzDarkButton() => tnDarkCta();
BoxDecoration tzDarkCard({double radius = 20}) => BoxDecoration(
  color: tnDark,
  borderRadius: BorderRadius.circular(radius),
);
BoxDecoration tzBadge2(String label, {Color? bg, Color? text, IconData? icon}) => tnPill();

Widget tzBadge(String label, {Color? bg, Color? text, IconData? icon}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: tnPill(bg: bg),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: text ?? tnMuted),
            const SizedBox(width: 4),
          ],
          Text(label, style: tnLabel(11, color: text ?? tnMuted)),
        ],
      ),
    );

// =====================================================================
// BACKGROUND GRADIENT — page-level scaffold background
// =====================================================================
Widget tnScaffoldBg({required Widget child}) => Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: bgGradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.5, 1.0],
    ),
  ),
  child: child,
);

// =====================================================================
// SHARED CARD WIDGETS (Legacy guide(), stepCard(), roundIcon())
// =====================================================================

Widget roundIcon(IconData icon, {Color? color, Color? bg}) => CircleAvatar(
  radius: 19,
  backgroundColor: bg ?? Colors.white,
  child: Icon(icon, size: 19, color: color ?? tnDark),
);

Widget guide(String title, String image, {String? rating, String? location}) =>
    Container(
      width: 170,
      margin: const EdgeInsets.only(right: 14),
      decoration: tnCardDecor(radius: 22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/$image?w=400',
              height: 200,
              width: 170,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.06),
                      Colors.black.withValues(alpha: 0.68),
                    ],
                    stops: const [0.35, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            if (rating != null)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: tnFrosted(radius: 100),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: tnAmber, size: 11),
                      const SizedBox(width: 3),
                      Text(rating, style: tnLabel(10)),
                    ],
                  ),
                ),
              ),
            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tnHead(13, color: Colors.white),
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '📍 $location',
                      style: tnBody(10.5, color: Colors.white.withValues(alpha: 0.82)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget stepCard(String title, String subtitle, String action) => Container(
  decoration: tnCardDecor(),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: boldItalicTitle(15)),
        const SizedBox(height: 5),
        Text(subtitle, style: tnBody(12)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(action, style: tnLabel(12.5, color: tnBlue)),
        ),
      ],
    ),
  ),
);
