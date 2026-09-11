import 'package:flutter/material.dart';

enum TripStatus {
  upcoming,
  ongoing,
  completed,
}

enum ItineraryPlanVersion {
  balanced,
  budget,
  comfort,
}

class TravellerInfo {
  final String id;
  final String name;
  final String avatarLetter;
  final Color avatarColor;
  final String mbti;
  final List<String> interests;
  final String? chatId;
  final String travelStyle;

  const TravellerInfo({
    required this.id,
    required this.name,
    required this.avatarLetter,
    required this.avatarColor,
    required this.mbti,
    required this.interests,
    this.chatId,
    required this.travelStyle,
  });
}

class ItineraryPlaceStop {
  final String id;
  String time;
  String name;
  String category;
  String categoryIcon;
  String address;
  String description;
  String duration;
  String estimatedCost;
  String distanceToNext;
  String travelMethod;
  double rating;
  int reviewCount;
  String whyRecommended;
  String googleMapsUrl;
  double lat;
  double lng;
  bool isHighlight;
  String? imageUrl;

  ItineraryPlaceStop({
    required this.id,
    required this.time,
    required this.name,
    required this.category,
    required this.categoryIcon,
    required this.address,
    required this.description,
    required this.duration,
    required this.estimatedCost,
    required this.distanceToNext,
    required this.travelMethod,
    required this.rating,
    required this.reviewCount,
    required this.whyRecommended,
    required this.googleMapsUrl,
    required this.lat,
    required this.lng,
    this.isHighlight = false,
    this.imageUrl,
  });

  ItineraryPlaceStop copyWith({
    String? time,
    String? name,
    String? category,
    String? categoryIcon,
    String? address,
    String? description,
    String? duration,
    String? estimatedCost,
    String? distanceToNext,
    String? travelMethod,
    double? rating,
    int? reviewCount,
    String? whyRecommended,
    String? googleMapsUrl,
    double? lat,
    double? lng,
    bool? isHighlight,
  }) {
    return ItineraryPlaceStop(
      id: id,
      time: time ?? this.time,
      name: name ?? this.name,
      category: category ?? this.category,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      address: address ?? this.address,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      distanceToNext: distanceToNext ?? this.distanceToNext,
      travelMethod: travelMethod ?? this.travelMethod,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      whyRecommended: whyRecommended ?? this.whyRecommended,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isHighlight: isHighlight ?? this.isHighlight,
    );
  }
}

class ItineraryDayData {
  final int dayNumber;
  final String date;
  String title;
  String summary;
  String walkingEstimate;
  String estimatedCost;
  List<ItineraryPlaceStop> stops;

  ItineraryDayData({
    required this.dayNumber,
    required this.date,
    required this.title,
    required this.summary,
    required this.walkingEstimate,
    required this.estimatedCost,
    required this.stops,
  });

  ItineraryDayData copyWith({
    String? title,
    String? summary,
    String? walkingEstimate,
    String? estimatedCost,
    List<ItineraryPlaceStop>? stops,
  }) {
    return ItineraryDayData(
      dayNumber: dayNumber,
      date: date,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      walkingEstimate: walkingEstimate ?? this.walkingEstimate,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      stops: stops ?? List.from(this.stops),
    );
  }
}

class TripRecommendation {
  final String id;
  final String title;
  final String category;
  final String categoryIcon;
  final double rating;
  final int reviewCount;
  final String whyRecommended;
  final String distance;
  final String travelTime;
  final int targetDayNumber;
  final ItineraryPlaceStop placeData;

  const TripRecommendation({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.rating,
    required this.reviewCount,
    required this.whyRecommended,
    required this.distance,
    required this.travelTime,
    required this.targetDayNumber,
    required this.placeData,
  });
}

class TripAiSuggestion {
  final String id;
  final String title;
  final String explanation;
  final String sourceNotebookQuote;
  final String proposedChangeDescription;
  final int targetDayNumber;
  bool isApplied;
  bool isIgnored;

  TripAiSuggestion({
    required this.id,
    required this.title,
    required this.explanation,
    required this.sourceNotebookQuote,
    required this.proposedChangeDescription,
    required this.targetDayNumber,
    this.isApplied = false,
    this.isIgnored = false,
  });
}

class AiItineraryChatMessage {
  final String id;
  final String sender;
  final String text;
  final String timestamp;
  final bool isAi;
  final TripAiSuggestion? attachedSuggestion;

  AiItineraryChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isAi,
    this.attachedSuggestion,
  });
}

class TripFolderItem {
  final String id;
  String name;
  String destination;
  String startDate;
  String endDate;
  DateTime startDateTime;
  DateTime endDateTime;
  TripStatus status;
  final String chatId;
  final String chatName;
  final List<TravellerInfo> travellers;
  final List<ItineraryDayData> days;
  int placesCount;
  String lastUpdated;
  int notebookDecisionsCount;
  final String mapPreviewUrl;
  final Color themeColor;
  final List<TripRecommendation> recommendations;
  final List<TripAiSuggestion> aiSuggestions;
  ItineraryPlanVersion currentVersion;
  final String? daysLeftBadge;
  final List<String>? tags;
  final String? coverImageUrl;

  TripFolderItem({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.startDateTime,
    required this.endDateTime,
    required this.status,
    required this.chatId,
    required this.chatName,
    required this.travellers,
    required this.days,
    required this.placesCount,
    required this.lastUpdated,
    required this.notebookDecisionsCount,
    required this.mapPreviewUrl,
    required this.themeColor,
    required this.recommendations,
    required this.aiSuggestions,
    this.currentVersion = ItineraryPlanVersion.balanced,
    this.daysLeftBadge,
    this.tags,
    this.coverImageUrl,
  });
}

// ----------------------------------------------------
// DEMO TRIPS REPOSITORY
// ----------------------------------------------------
class TripRepository {
  static List<TripFolderItem> getDemoTrips() {
    // ------------------------------------------------
    // 1. TOKYO ADVENTURE (Main Demo Scenario)
    // ------------------------------------------------
    final tokyoTravellers = [
      const TravellerInfo(
        id: 't_maya',
        name: 'Maya',
        avatarLetter: 'M',
        avatarColor: Color(0xFF10B981),
        mbti: 'ENFP',
        interests: ['Photography', 'Café Hopping', 'Art Exhibits'],
        chatId: 'maya_direct',
        travelStyle: 'Spontaneous & Visual',
      ),
      const TravellerInfo(
        id: 't_daniel',
        name: 'Daniel',
        avatarLetter: 'D',
        avatarColor: Color(0xFF3B82F6),
        mbti: 'ENTP',
        interests: ['Food & Ramen', 'Specialty Coffee', 'Budget Tracking'],
        chatId: 'daniel_direct',
        travelStyle: 'Foodie & Value-Conscious',
      ),
      const TravellerInfo(
        id: 't_sarah',
        name: 'Sarah',
        avatarLetter: 'S',
        avatarColor: Color(0xFFEC4899),
        mbti: 'INFP',
        interests: ['Gardens', 'Relaxed Pace', 'Cozy Shops'],
        chatId: 'sarah_direct',
        travelStyle: 'Gentle Pace & Serene Walks',
      ),
      const TravellerInfo(
        id: 't_you',
        name: 'You',
        avatarLetter: 'Y',
        avatarColor: Color(0xFFFF5A5F),
        mbti: 'INFJ',
        interests: ['City Exploration', 'Culture', 'Scenic Views'],
        chatId: null,
        travelStyle: 'Balanced Planner',
      ),
    ];

    // Day 1 Stops (Seoul / Shibuya & Harajuku)
    final day1Stops = [
      ItineraryPlaceStop(
        id: 'p_1_1',
        time: '11:00',
        name: 'Anthracite Coffee Roasters',
        category: 'Café',
        categoryIcon: '☕',
        address: '1-7-3 Jinnan, Shibuya-ku, Tokyo',
        description: 'Converted shoe factory serving dark roast single origins.',
        duration: '1 hour',
        estimatedCost: '₩6,500 (~RM22)',
        distanceToNext: '800m',
        travelMethod: 'Walk 800m (about 10 min)',
        rating: 4.5,
        reviewCount: 1840,
        whyRecommended: 'Perfect morning coffee gathering; matches Daniel and Maya’s café preferences.',
        googleMapsUrl: 'https://maps.google.com/?q=Anthracite+Coffee+Roasters+Seoul',
        lat: 37.5492,
        lng: 126.9135,
        imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500',
      ),
      ItineraryPlaceStop(
        id: 'p_1_2',
        time: '13:00',
        name: 'Yeonnam-dong Gyeongui Line Forest Park',
        category: 'Nature & Stroll',
        categoryIcon: '🌳',
        address: 'Yeonnam-dong, Seoul',
        description: 'A charming greenway with cafes, trees and a laid-back atmosphere in the heart of Hongdae.',
        duration: '1.5 hours',
        estimatedCost: 'Free',
        distanceToNext: '1.2 km',
        travelMethod: 'Walk 1.2 km (about 15 min)',
        rating: 4.6,
        reviewCount: 14200,
        whyRecommended: 'Charming greenway stroll with coffee and trees.',
        googleMapsUrl: 'https://maps.google.com/?q=Gyeongui+Line+Forest+Park+Seoul',
        lat: 37.5615,
        lng: 126.9242,
        imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
      ),
      ItineraryPlaceStop(
        id: 'p_1_3',
        time: '15:30',
        name: 'Hongdae Street',
        category: 'Shopping & Explore',
        categoryIcon: '🛍️',
        address: 'Hongdae, Seoul',
        description: 'Trendy shops, street food and a youthful vibe. A must-visit in Seoul.',
        duration: '2 hours',
        estimatedCost: 'Free',
        distanceToNext: 'End of Day 1',
        travelMethod: 'Short walk',
        rating: 4.4,
        reviewCount: 22000,
        whyRecommended: 'Youthful vibe, indie boutiques, and street food.',
        googleMapsUrl: 'https://maps.google.com/?q=Hongdae+Street+Seoul',
        lat: 37.5545,
        lng: 126.9220,
        imageUrl: 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=500',
      ),
    ];

    // Day 2 Stops (TeamLab & Modern Tokyo - Initially starts early at 08:00 before AI optimization!)
    final day2Stops = [
      ItineraryPlaceStop(
        id: 'p_2_1',
        time: '08:00', // NOTE: Early morning start that triggers AI Notebook suggestion!
        name: 'TeamLab Borderless Digital Art Museum',
        category: 'Must Visit',
        categoryIcon: '📍',
        address: 'Azabudai Hills Garden Plaza B B1F, Tokyo',
        description: 'World-renowned immersive digital light museum with borderless interactive rooms.',
        duration: '2.5 hours',
        estimatedCost: '¥4,200 (~RM130)',
        distanceToNext: '4.2 km · 20 min transit',
        travelMethod: 'Hibiya Line towards Ginza',
        rating: 4.9,
        reviewCount: 38000,
        whyRecommended: 'Preserved from Maya’s message in Tokyo Squad Notebook: "I really want to visit TeamLab Borderless."',
        googleMapsUrl: 'https://maps.google.com/?q=teamLab+Borderless+Azabudai+Hills+Tokyo',
        lat: 35.6606,
        lng: 139.7432,
        isHighlight: true,
      ),
      ItineraryPlaceStop(
        id: 'p_2_2',
        time: '11:30',
        name: 'Ginza Six & Café Dior',
        category: 'Food & Cafés',
        categoryIcon: '☕',
        address: '6-10-1 Ginza, Chuo-ku, Tokyo',
        description: 'Luxury architecture, rooftop garden, and Daniel’s recommended coffee stop.',
        duration: '1.5 hours',
        estimatedCost: '¥1,800 (~RM56)',
        distanceToNext: '1.2 km · 14 min walk',
        travelMethod: 'Walk via Ginza Avenue',
        rating: 4.4,
        reviewCount: 6800,
        whyRecommended: 'Saved from Daniel’s discussion regarding coffee and scenic architecture.',
        googleMapsUrl: 'https://maps.google.com/?q=Ginza+Six+Tokyo',
        lat: 35.6696,
        lng: 139.7640,
      ),
      ItineraryPlaceStop(
        id: 'p_2_3',
        time: '14:00',
        name: 'Tokyo Station Character Street & Imperial Gardens',
        category: 'Sightseeing',
        categoryIcon: '⛩️',
        address: '1-9-1 Marunouchi, Chiyoda-ku, Tokyo',
        description: 'Historic red-brick station plaza, easy indoor underground shopping, and castle moats.',
        duration: '2 hours',
        estimatedCost: 'Free entry',
        distanceToNext: 'End of Day 2',
        travelMethod: 'Yamanote Line return',
        rating: 4.6,
        reviewCount: 15400,
        whyRecommended: 'Smooth indoor walking avoiding weather fatigue.',
        googleMapsUrl: 'https://maps.google.com/?q=Tokyo+Station+Character+Street',
        lat: 35.6812,
        lng: 139.7671,
      ),
    ];

    // Day 3 Stops (Asakusa, Ueno, Akihabara - High walking distance that triggers AI optimization!)
    final day3Stops = [
      ItineraryPlaceStop(
        id: 'p_3_1',
        time: '10:30',
        name: 'Senso-ji Temple & Nakamise-dori',
        category: 'Culture',
        categoryIcon: '⛩️',
        address: '2-3-1 Asakusa, Taito-ku, Tokyo',
        description: 'Tokyo’s oldest Buddhist temple with traditional wooden stalls selling freshly pressed senbei crackers.',
        duration: '1.5 hours',
        estimatedCost: 'Free entry',
        distanceToNext: '2.4 km walking gap',
        travelMethod: '2.4 km walking gap (Triggers AI route alert)',
        rating: 4.7,
        reviewCount: 46000,
        whyRecommended: 'Essential cultural heritage stop with great photography angles.',
        googleMapsUrl: 'https://maps.google.com/?q=Sensoji+Temple+Asakusa+Tokyo',
        lat: 35.7148,
        lng: 139.7967,
        isHighlight: true,
      ),
      ItineraryPlaceStop(
        id: 'p_3_2',
        time: '13:00',
        name: 'Ueno Park & Ameyoko Market',
        category: 'Market',
        categoryIcon: '🛍️',
        address: 'Uenokoen, Taito-ku, Tokyo',
        description: 'Bustling post-war market street with fresh seafood bowls and fruit skewers.',
        duration: '2 hours',
        estimatedCost: '¥1,500 (~RM46)',
        distanceToNext: '1.6 km · 18 min walk',
        travelMethod: 'Walk south along railway viaduct',
        rating: 4.3,
        reviewCount: 19800,
        whyRecommended: 'Vibrant retro atmosphere and budget street dining.',
        googleMapsUrl: 'https://maps.google.com/?q=Ameyoko+Shopping+Street+Tokyo',
        lat: 35.7115,
        lng: 139.7745,
      ),
      ItineraryPlaceStop(
        id: 'p_3_3',
        time: '16:00',
        name: 'Akihabara Electric Town & Retro Arcade',
        category: 'Activities',
        categoryIcon: '🎯',
        address: 'Sotokanda, Chiyoda-ku, Tokyo',
        description: 'Neon-lit anime, gaming, and collectible district.',
        duration: '2 hours',
        estimatedCost: '¥1,000 (~RM30)',
        distanceToNext: 'End of Day 3',
        travelMethod: 'Direct JR Yamanote Line',
        rating: 4.5,
        reviewCount: 28000,
        whyRecommended: 'Fun evening entertainment for the whole group.',
        googleMapsUrl: 'https://maps.google.com/?q=Akihabara+Electric+Town+Tokyo',
        lat: 35.6983,
        lng: 139.7731,
      ),
    ];

    // Day 4 Stops (Shimokitazawa & Shinjuku)
    final day4Stops = [
      ItineraryPlaceStop(
        id: 'p_4_1',
        time: '11:00',
        name: 'Shimokitazawa Vintage Boutiques',
        category: 'Shopping',
        categoryIcon: '🛍️',
        address: 'Kitazawa, Setagaya-ku, Tokyo',
        description: 'Bohemian neighborhood filled with indie records, curated vintage, and specialty roasters.',
        duration: '2.5 hours',
        estimatedCost: 'Discretionary',
        distanceToNext: 'Odakyu Line (8 min transit)',
        travelMethod: 'Express train to Shinjuku',
        rating: 4.6,
        reviewCount: 7800,
        whyRecommended: 'Relaxed thrift browsing with minimal crowd pressure.',
        googleMapsUrl: 'https://maps.google.com/?q=Shimokitazawa+Tokyo',
        lat: 35.6617,
        lng: 139.6675,
      ),
      ItineraryPlaceStop(
        id: 'p_4_2',
        time: '14:30',
        name: 'Bear Pond Espresso',
        category: 'Café',
        categoryIcon: '☕',
        address: '2-36-12 Kitazawa, Setagaya-ku, Tokyo',
        description: 'Cult specialty coffee shop famed for Angel Stain espresso shots.',
        duration: '45 mins',
        estimatedCost: '¥650 (~RM20)',
        distanceToNext: 'Short train ride',
        travelMethod: 'Transit to Shinjuku Gyoen',
        rating: 4.4,
        reviewCount: 1600,
        whyRecommended: 'Saved from Daniel’s coffee list in the Travel Notebook.',
        googleMapsUrl: 'https://maps.google.com/?q=Bear+Pond+Espresso+Tokyo',
        lat: 35.6631,
        lng: 139.6689,
      ),
      ItineraryPlaceStop(
        id: 'p_4_3',
        time: '17:00',
        name: 'Shinjuku Omoide Yokocho & Kabukicho',
        category: 'Dinner',
        categoryIcon: '🏮',
        address: '1-2 Nishishinjuku, Shinjuku-ku, Tokyo',
        description: 'Atmospheric lantern-lit alleyways with traditional yakitori and gyoza.',
        duration: '2 hours',
        estimatedCost: '¥2,200 (~RM68)',
        distanceToNext: 'End of Day 4',
        travelMethod: 'Walk back to hotel',
        rating: 4.5,
        reviewCount: 11000,
        whyRecommended: 'Vibrant night dining without busting the RM250 hotel/dinner target.',
        googleMapsUrl: 'https://maps.google.com/?q=Omoide+Yokocho+Shinjuku+Tokyo',
        lat: 35.6934,
        lng: 139.6997,
      ),
    ];

    // Day 5 Stops (Tsukiji & Odaiba Seaside)
    final day5Stops = [
      ItineraryPlaceStop(
        id: 'p_5_1',
        time: '10:30',
        name: 'Tsukiji Outer Market Food Crawl',
        category: 'Food',
        categoryIcon: '🍣',
        address: '4-16-2 Tsukiji, Chuo-ku, Tokyo',
        description: 'Fresh grilled scallops, tamagoyaki skewers, and wagyu beef bowls.',
        duration: '2 hours',
        estimatedCost: '¥2,500 (~RM78)',
        distanceToNext: 'Yurikamome line (15 min transit)',
        travelMethod: 'Scenic bay view transit',
        rating: 4.6,
        reviewCount: 26000,
        whyRecommended: 'Satisfies Daniel’s foodie requests while starting at a relaxed 10:30 AM.',
        googleMapsUrl: 'https://maps.google.com/?q=Tsukiji+Outer+Market+Tokyo',
        lat: 35.6655,
        lng: 139.7707,
      ),
      ItineraryPlaceStop(
        id: 'p_5_2',
        time: '14:00',
        name: 'Odaiba Seaside Park & Rainbow Bridge Sunset',
        category: 'Sightseeing',
        categoryIcon: '🌊',
        address: '1-4 Daiba, Minato-ku, Tokyo',
        description: 'Seaside promenade with Tokyo Bay breezes, replica Statue of Liberty, and Rainbow Bridge panorama.',
        duration: '2.5 hours',
        estimatedCost: 'Free entry',
        distanceToNext: 'Trip wrap-up & Narita Express',
        travelMethod: 'Airport Express transit',
        rating: 4.7,
        reviewCount: 14000,
        whyRecommended: 'Tranquil seaside departure with zero rushing.',
        googleMapsUrl: 'https://maps.google.com/?q=Odaiba+Seaside+Park+Tokyo',
        lat: 35.6307,
        lng: 139.7753,
      ),
    ];

    final tokyoDays = [
      ItineraryDayData(
        dayNumber: 1,
        date: 'Thu, Nov 12',
        title: 'Shibuya & Harajuku Culture',
        summary: 'Kitaya Park café, vintage street fashion, and Shibuya Sky golden hour.',
        walkingEstimate: '11,200 steps (Pace: Relaxed)',
        estimatedCost: '¥4,550 (~RM142/pax)',
        stops: day1Stops,
      ),
      ItineraryDayData(
        dayNumber: 2,
        date: 'Fri, Nov 13',
        title: 'TeamLab Borderless & Modern Tokyo',
        summary: 'Digital light art, Ginza architecture, and historic Tokyo Station.',
        walkingEstimate: '13,800 steps (Pace: Moderate)',
        estimatedCost: '¥6,000 (~RM186/pax)',
        stops: day2Stops,
      ),
      ItineraryDayData(
        dayNumber: 3,
        date: 'Sat, Nov 14',
        title: 'Asakusa Tradition & Akihabara Tech',
        summary: 'Historic Senso-ji temple, Ameyoko street food, and retro electric arcades.',
        walkingEstimate: '15,400 steps (Pace: High walking)',
        estimatedCost: '¥2,500 (~RM76/pax)',
        stops: day3Stops,
      ),
      ItineraryDayData(
        dayNumber: 4,
        date: 'Sun, Nov 15',
        title: 'Shimokitazawa Vintage & Shinjuku Night',
        summary: 'Curated thrift shops, Bear Pond espresso, and lantern-lit izakaya alleyways.',
        walkingEstimate: '9,800 steps (Pace: Very Relaxed)',
        estimatedCost: '¥3,850 (~RM118/pax)',
        stops: day4Stops,
      ),
      ItineraryDayData(
        dayNumber: 5,
        date: 'Mon, Nov 16',
        title: 'Tsukiji Market & Odaiba Seaside Sunset',
        summary: 'Morning seafood tasting and serene Tokyo Bay skyline breezes.',
        walkingEstimate: '7,600 steps (Pace: Light)',
        estimatedCost: '¥3,200 (~RM98/pax)',
        stops: day5Stops,
      ),
    ];

    // Recommendations (Places You Might Love)
    final tokyoRecommendations = [
      TripRecommendation(
        id: 'rec_1',
        title: 'Fuglen Tokyo',
        category: 'Café & Roastery',
        categoryIcon: '☕',
        rating: 4.6,
        reviewCount: 3400,
        whyRecommended: 'Matches 3 travellers’ interest in specialty coffee and vintage Scandinavian design.',
        distance: '12 min from your Day 1 route',
        travelTime: '7 min walk from Yoyogi Park',
        targetDayNumber: 1,
        placeData: ItineraryPlaceStop(
          id: 'p_rec_1',
          time: '15:15',
          name: 'Fuglen Tokyo',
          category: 'Café',
          categoryIcon: '☕',
          address: '1-16-11 Tomigaya, Shibuya-ku, Tokyo',
          description: 'Norwegian coffee shop by day and craft cocktail bar by night near Yoyogi Park.',
          duration: '45 mins',
          estimatedCost: '¥700 (~RM22)',
          distanceToNext: '400m to Shibuya Sky',
          travelMethod: 'Walk',
          rating: 4.6,
          reviewCount: 3400,
          whyRecommended: 'Saved from group discussion regarding artisanal coffee.',
          googleMapsUrl: 'https://maps.google.com/?q=Fuglen+Tokyo',
          lat: 35.6667,
          lng: 139.6922,
        ),
      ),
      TripRecommendation(
        id: 'rec_2',
        title: 'Kappabashi Kitchen Street',
        category: 'Culture & Shopping',
        categoryIcon: '🔪',
        rating: 4.5,
        reviewCount: 6200,
        whyRecommended: 'Bridges the 2.4 km walking gap between Asakusa and Ueno on Day 3 with authentic Japanese knife shops.',
        distance: 'Direct path on Day 3',
        travelTime: 'Direct 6 min stroll',
        targetDayNumber: 3,
        placeData: ItineraryPlaceStop(
          id: 'p_rec_2',
          time: '12:15',
          name: 'Kappabashi Kitchen Street',
          category: 'Shopping',
          categoryIcon: '🔪',
          address: 'Matsugaya, Taito-ku, Tokyo',
          description: 'Historic merchant district dedicated to chef knives, handcrafted ceramics, and food replicas.',
          duration: '45 mins',
          estimatedCost: 'Free browsing',
          distanceToNext: '800m to Ueno',
          travelMethod: 'Walk',
          rating: 4.5,
          reviewCount: 6200,
          whyRecommended: 'Smooth route bridge preventing walking fatigue.',
          googleMapsUrl: 'https://maps.google.com/?q=Kappabashi+Kitchen+Street+Tokyo',
          lat: 35.7133,
          lng: 139.7892,
        ),
      ),
      TripRecommendation(
        id: 'rec_3',
        title: 'Ramen Street inside Tokyo Station',
        category: 'Food',
        categoryIcon: '🍜',
        rating: 4.4,
        reviewCount: 5100,
        whyRecommended: 'Keeps dinner budget under RM250/night while serving legendary Rokurinsha tsukemen.',
        distance: 'Inside Day 2 stop',
        travelTime: '0 min (already at station)',
        targetDayNumber: 2,
        placeData: ItineraryPlaceStop(
          id: 'p_rec_3',
          time: '16:30',
          name: 'Rokurinsha Tsukemen (Tokyo Station)',
          category: 'Food',
          categoryIcon: '🍜',
          address: 'Tokyo Station Ichiban-gai B1F, Tokyo',
          description: 'Legendary thick noodles dipped in rich pork-and-bonito broth.',
          duration: '45 mins',
          estimatedCost: '¥1,050 (~RM32)',
          distanceToNext: 'Return home',
          travelMethod: 'Subway',
          rating: 4.4,
          reviewCount: 5100,
          whyRecommended: 'Directly aligns with Daniel’s ramen recommendation in chat.',
          googleMapsUrl: 'https://maps.google.com/?q=Rokurinsha+Tokyo+Station',
          lat: 35.6811,
          lng: 139.7670,
        ),
      ),
    ];

    // AI Suggestions based on Notebook analysis
    final tokyoAiSuggestions = [
      TripAiSuggestion(
        id: 'sug_late_start',
        title: 'Move Day 2 Start to 10:30 AM',
        explanation:
            'Your Notebook mentions that everyone prefers a slower morning (~10:30 AM). Day 2 currently starts early at 08:00 AM.',
        sourceNotebookQuote: '"Let\'s start around 10:30 instead of 8am to keep it relaxed."',
        proposedChangeDescription:
            'Adjust TeamLab Borderless to 10:30 AM priority slot, shifting Ginza lunch to 13:30 and Tokyo Station to 15:30.',
        targetDayNumber: 2,
      ),
      TripAiSuggestion(
        id: 'sug_walking_gap',
        title: 'Bridge Day 3 Walking Gap with Kappabashi',
        explanation:
            'Sarah requested keeping daily steps under 15k. Day 3 currently has a 2.4 km walking gap between Asakusa and Ueno with 15,400 estimated steps.',
        sourceNotebookQuote: '"Can we avoid too much walking? Max ~15k steps please!"',
        proposedChangeDescription:
            'Add Kappabashi Kitchen Street stop or recommend Ginza Line subway (2 stops, 4 min) to reduce walking to 11,200 steps.',
        targetDayNumber: 3,
      ),
      TripAiSuggestion(
        id: 'sug_add_cafe',
        title: 'Include Daniel’s Café Recommendation on Day 1',
        explanation:
            'Daniel shared a coffee spot near Shibuya in chat, but it is not yet placed in your Day 1 timeline.',
        sourceNotebookQuote: '"I found a great café near Shibuya for breakfast."',
        proposedChangeDescription:
            'Integrate Blue Bottle or Fuglen Tokyo into Day 1 at 10:30 AM before Harajuku.',
        targetDayNumber: 1,
        isApplied: true, // Already reflected in initial day 1!
      ),
    ];

    final tokyoTrip = TripFolderItem(
      id: 'trip_tokyo_2026',
      name: 'Tokyo Adventure',
      destination: 'Tokyo, Japan',
      startDate: '12 Nov',
      endDate: '16 Nov 2026',
      startDateTime: DateTime(2026, 11, 12),
      endDateTime: DateTime(2026, 11, 16),
      status: TripStatus.upcoming,
      chatId: 'tokyo_squad',
      chatName: 'Tokyo Squad',
      travellers: tokyoTravellers,
      days: tokyoDays,
      placesCount: 16,
      lastUpdated: '10 min ago',
      notebookDecisionsCount: 4,
      mapPreviewUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800',
      coverImageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800',
      daysLeftBadge: '12 days left',
      tags: const ['City', 'Food', 'Culture', '+2'],
      themeColor: const Color(0xFFFF5A5F),
      recommendations: tokyoRecommendations,
      aiSuggestions: tokyoAiSuggestions,
    );

    // ------------------------------------------------
    // 2. SANTORINI ESCAPE (ONGOING)
    // ------------------------------------------------
    final santoriniTrip = TripFolderItem(
      id: 'trip_santorini_2026',
      name: 'Santorini Escape',
      destination: 'Santorini, Greece',
      startDate: '3 Sep',
      endDate: '9 Sep 2026',
      startDateTime: DateTime(2026, 9, 3),
      endDateTime: DateTime(2026, 9, 9),
      status: TripStatus.ongoing,
      chatId: 'daniel_direct',
      chatName: 'Daniel',
      travellers: tokyoTravellers,
      days: tokyoDays,
      placesCount: 12,
      lastUpdated: '1 hour ago',
      notebookDecisionsCount: 3,
      mapPreviewUrl: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800',
      coverImageUrl: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800',
      daysLeftBadge: 'Ongoing',
      tags: const ['Beaches', 'Relaxation', 'Photography', '+1'],
      themeColor: const Color(0xFF3B82F6),
      recommendations: [],
      aiSuggestions: [],
    );

    // ------------------------------------------------
    // 3. CANADIAN ROCKIES (PAST)
    // ------------------------------------------------
    final rockiesTrip = TripFolderItem(
      id: 'trip_rockies_2026',
      name: 'Canadian Rockies',
      destination: 'Banff, Canada',
      startDate: '15 Jun',
      endDate: '20 Jun 2026',
      startDateTime: DateTime(2026, 6, 15),
      endDateTime: DateTime(2026, 6, 20),
      status: TripStatus.completed,
      chatId: 'japan_2026',
      chatName: 'Japan 2026',
      travellers: tokyoTravellers,
      days: tokyoDays,
      placesCount: 10,
      lastUpdated: 'Yesterday',
      notebookDecisionsCount: 2,
      mapPreviewUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      coverImageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      daysLeftBadge: 'Past trip',
      tags: const ['Nature', 'Hiking', 'Scenery', '+1'],
      themeColor: const Color(0xFF10B981),
      recommendations: [],
      aiSuggestions: [],
    );

    return [tokyoTrip, santoriniTrip, rockiesTrip];
  }
}
