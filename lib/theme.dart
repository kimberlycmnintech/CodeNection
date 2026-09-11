import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF0F172A); // Midnight Navy from new mockup
const coral = primaryColor; // alias for existing references
const iceBg = Color(0xFFEBF4FB); // Ice Blue background tint
const mintBg = iceBg; // alias for existing screen backgrounds
const darkSlate = Color(0xFF0F172A);
const azureBlue = Color(0xFF2563EB); // Vibrant Sky Azure
const skyAccent = Color(0xFF38BDF8);
const lightAzure = Color(0xFFE0F2FE);

TextStyle boldItalicTitle(double size, {Color? color, double? height}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      color: color ?? darkSlate,
      height: height,
      letterSpacing: -0.5,
    );

TextStyle boldTitle(double size, {Color? color}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: color ?? darkSlate,
    );

TextStyle bodyFont(double size, {Color? color, FontWeight? weight}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? const Color(0xFF64748B),
      fontWeight: weight ?? FontWeight.w500,
    );

Widget roundIcon(IconData icon, {Color? color, Color? bg}) => CircleAvatar(
      radius: 19,
      backgroundColor: bg ?? Colors.white,
      child: Icon(icon, size: 19, color: color ?? darkSlate),
    );

Widget guide(String title, String image, {String? rating, String? location}) => Container(
      width: 175,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/$image?w=400',
              height: 200,
              width: 175,
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
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            if (rating != null)
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        rating,
                        style: GoogleFonts.plusJakartaSans(
                          color: darkSlate,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              left: 12,
              bottom: 12,
              right: rating != null ? 58 : 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: boldItalicTitle(14, color: Colors.white),
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      location,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget stepCard(String title, String subtitle, String action) => Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue.shade50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: boldItalicTitle(15, color: darkSlate)),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: bodyFont(12),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                action,
                style: GoogleFonts.plusJakartaSans(
                  color: azureBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );

