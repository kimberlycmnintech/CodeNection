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

    // Day 1 Stops (Shibuya & Harajuku)
    final day1Stops = [
      ItineraryPlaceStop(
        id: 'p_1_1',
        time: '10:30',
        name: 'Blue Bottle Coffee Shibuya',
        category: 'Café',
        categoryIcon: '☕',
        address: '1-7-3 Jinnan, Shibuya-ku, Tokyo',
        description: 'Specialty pour-over coffee overlooking Kitaya Park.',
        duration: '45 mins',
        estimatedCost: '¥750 (~RM24)',
        distanceToNext: '850m · 11 min walk',
        travelMethod: 'Walk through leafy backstreets',
        rating: 4.6,
        reviewCount: 1840,
        whyRecommended: 'Perfect for morning gathering; matches Daniel and Maya’s café preferences.',
        googleMapsUrl: 'https://maps.google.com/?q=Blue+Bottle+Coffee+Shibuya+Tokyo',
        lat: 35.6635,
        lng: 139.7005,
      ),
      ItineraryPlaceStop(
        id: 'p_1_2',
        time: '11:45',
        name: 'Harajuku Takeshita Street & Cat Street',
        category: 'Shopping',
        categoryIcon: '🛍️',
        address: 'Jingumae, Shibuya-ku, Tokyo',
        description: 'Vibrant boutique street with vintage clothes, street snacks, and indie designers.',
        duration: '1.5 hours',
        estimatedCost: 'Free entry (Budget discretionary)',
        distanceToNext: '600m · 8 min walk',
        travelMethod: 'Walk past Meiji-Jingumae station',
        rating: 4.3,
        reviewCount: 14200,
        whyRecommended: 'Iconic Tokyo youth fashion culture and easy thrift browsing.',
        googleMapsUrl: 'https://maps.google.com/?q=Takeshita+Street+Harajuku+Tokyo',
        lat: 35.6702,
        lng: 139.7027,
      ),
      ItineraryPlaceStop(
        id: 'p_1_3',
        time: '13:30',
        name: 'Yoyogi Park & Meiji Jingu Forest',
        category: 'Nature',
        categoryIcon: '🌳',
        address: '2-1 Yoyogikamizonocho, Shibuya-ku, Tokyo',
        description: 'Peaceful forested shrine grounds providing quiet respite between shopping stops.',
        duration: '1.5 hours',
        estimatedCost: 'Free entry',
        distanceToNext: '1.4 km · 15 min walk / 1 stop transit',
        travelMethod: 'Fukutoshin Line to Shibuya',
        rating: 4.7,
        reviewCount: 22000,
        whyRecommended: 'Matches Sarah’s preference for tranquil nature and resting feet.',
        googleMapsUrl: 'https://maps.google.com/?q=Yoyogi+Park+Tokyo',
        lat: 35.6717,
        lng: 139.6949,
      ),
      ItineraryPlaceStop(
        id: 'p_1_4',
        time: '16:00',
        name: 'Shibuya Sky Observation Deck',
        category: 'Observation Deck',
        categoryIcon: '🗼',
        address: '2-24-12 Shibuya, Shibuya Scramble Square 47F',
        description: '360-degree open-air rooftop observation deck with panoramic sunset views over Mount Fuji.',
        duration: '1.5 hours',
        estimatedCost: '¥2,500 (~RM78)',
        distanceToNext: '300m · 4 min walk',
        travelMethod: 'Elevator down to Scramble Crossing',
        rating: 4.8,
        reviewCount: 16500,
        whyRecommended: 'Priority golden hour photo stop; universally loved by the whole flock.',
        googleMapsUrl: 'https://maps.google.com/?q=Shibuya+Sky+Tokyo',
        lat: 35.6585,
        lng: 139.7022,
        isHighlight: true,
      ),
      ItineraryPlaceStop(
        id: 'p_1_5',
        time: '19:00',
        name: 'Ichiran Shibuya or Local Izakaya Alley',
        category: 'Dinner',
        categoryIcon: '🍜',
        address: '1-22-7 Jinnan, Shibuya-ku, Tokyo',
        description: 'Customized rich tonkotsu broth ramen with secret spicy red sauce.',
        duration: '1 hour',
        estimatedCost: '¥1,300 (~RM40)',
        distanceToNext: 'End of Day 1',
        travelMethod: 'Short walk back to Shibuya Hotel',
        rating: 4.5,
        reviewCount: 9400,
        whyRecommended: 'Comfort food to wrap up Day 1 under budget constraints.',
        googleMapsUrl: 'https://maps.google.com/?q=Ichiran+Ramen+Shibuya+Tokyo',
        lat: 35.6610,
        lng: 139.7001,
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
      mapPreviewUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=400',
      themeColor: const Color(0xFFFF5A5F),
      recommendations: tokyoRecommendations,
      aiSuggestions: tokyoAiSuggestions,
    );

    // ------------------------------------------------
    // 2. SEOUL FOOD TRIP (Second Trip Folder)
    // ------------------------------------------------
    final seoulTravellers = [
      const TravellerInfo(
        id: 't_daniel_2',
        name: 'Daniel',
        avatarLetter: 'D',
        avatarColor: Color(0xFF3B82F6),
        mbti: 'ENTP',
        interests: ['Street Food', 'K-BBQ', 'Boutique Cafés'],
        chatId: 'daniel_direct',
        travelStyle: 'Foodie Explorer',
      ),
      const TravellerInfo(
        id: 't_alex',
        name: 'Alex',
        avatarLetter: 'A',
        avatarColor: Color(0xFF8B5CF6),
        mbti: 'ISTJ',
        interests: ['History', 'Palaces', 'Budget Stays'],
        chatId: null,
        travelStyle: 'Organized & History-loving',
      ),
      const TravellerInfo(
        id: 't_you_2',
        name: 'You',
        avatarLetter: 'Y',
        avatarColor: Color(0xFFFF5A5F),
        mbti: 'INFJ',
        interests: ['Café Hopping', 'Culture'],
        chatId: null,
        travelStyle: 'Balanced',
      ),
    ];

    final seoulDays = [
      ItineraryDayData(
        dayNumber: 1,
        date: 'Sun, Dec 20',
        title: 'Hongdae & Yeonnam-dong Cafés',
        summary: 'Indie fashion, vinyl record cafés, and lively street busking.',
        walkingEstimate: '9,200 steps',
        estimatedCost: '₩42,000 (~RM140)',
        stops: [
          ItineraryPlaceStop(
            id: 's_1_1',
            time: '11:00',
            name: 'Anthracite Coffee Roasters',
            category: 'Café',
            categoryIcon: '☕',
            address: 'Hapjeong-dong, Mapo-gu, Seoul',
            description: 'Converted shoe factory serving dark roast single origins.',
            duration: '1 hour',
            estimatedCost: '₩6,500 (~RM22)',
            distanceToNext: '800m',
            travelMethod: 'Walk',
            rating: 4.5,
            reviewCount: 2200,
            whyRecommended: 'Saved from Daniel’s Seoul list.',
            googleMapsUrl: 'https://maps.google.com/?q=Anthracite+Coffee+Seoul',
            lat: 37.5492,
            lng: 126.9135,
          ),
          ItineraryPlaceStop(
            id: 's_1_2',
            time: '13:00',
            name: 'Yeonnam-dong Gyeongui Line Forest Park',
            category: 'Nature & Stroll',
            categoryIcon: '🌳',
            address: 'Yeonnam-dong, Seoul',
            description: 'Linear urban park lined with boutique shops and bakeries.',
            duration: '1.5 hours',
            estimatedCost: 'Free',
            distanceToNext: '1.2 km',
            travelMethod: 'Walk',
            rating: 4.6,
            reviewCount: 4800,
            whyRecommended: 'Scenic relaxed walk under 10k steps.',
            googleMapsUrl: 'https://maps.google.com/?q=Gyeongui+Line+Forest+Park+Seoul',
            lat: 37.5615,
            lng: 126.9242,
          ),
          ItineraryPlaceStop(
            id: 's_1_3',
            time: '18:00',
            name: 'Hongdae K-BBQ Alley',
            category: 'Dinner',
            categoryIcon: '🥩',
            address: 'Eoulmadang-ro, Mapo-gu, Seoul',
            description: 'Thick charcoal-grilled pork belly with aged kimchi stew.',
            duration: '2 hours',
            estimatedCost: '₩24,000 (~RM80)',
            distanceToNext: 'Hotel return',
            travelMethod: 'Short walk',
            rating: 4.7,
            reviewCount: 7900,
            whyRecommended: 'Top voted dinner in Daniel & Foodies chat.',
            googleMapsUrl: 'https://maps.google.com/?q=Hongdae+K+BBQ+Seoul',
            lat: 37.5545,
            lng: 126.9220,
            isHighlight: true,
          ),
        ],
      ),
      ItineraryDayData(
        dayNumber: 2,
        date: 'Mon, Dec 21',
        title: 'Bukchon Hanok Village & Insadong',
        summary: 'Traditional Korean architecture, tea houses, and Gyeongbokgung palace.',
        walkingEstimate: '11,000 steps',
        estimatedCost: '₩35,000 (~RM118)',
        stops: [
          ItineraryPlaceStop(
            id: 's_2_1',
            time: '10:30',
            name: 'Gyeongbokgung Palace & Hanbok Rental',
            category: 'Culture',
            categoryIcon: '🏯',
            address: '161 Sajik-ro, Jongno-gu, Seoul',
            description: 'Grand royal palace with royal guard changing ceremony.',
            duration: '2.5 hours',
            estimatedCost: '₩15,000 (~RM50)',
            distanceToNext: '600m walk',
            travelMethod: 'Walk',
            rating: 4.8,
            reviewCount: 35000,
            whyRecommended: 'Historic heritage match for Alex.',
            googleMapsUrl: 'https://maps.google.com/?q=Gyeongbokgung+Palace+Seoul',
            lat: 37.5796,
            lng: 126.9770,
            isHighlight: true,
          ),
          ItineraryPlaceStop(
            id: 's_2_2',
            time: '14:00',
            name: 'Insadong Traditional Tea House',
            category: 'Café',
            categoryIcon: '🍵',
            address: 'Insadong-gil, Jongno-gu, Seoul',
            description: 'Warm ginger and jujube teas served with traditional honey yakgwa.',
            duration: '1 hour',
            estimatedCost: '₩8,000 (~RM27)',
            distanceToNext: 'End of Day 2',
            travelMethod: 'Metro',
            rating: 4.5,
            reviewCount: 3100,
            whyRecommended: 'Resting stop avoiding cold December breezes.',
            googleMapsUrl: 'https://maps.google.com/?q=Insadong+Traditional+Tea+House+Seoul',
            lat: 37.5744,
            lng: 126.9856,
          ),
        ],
      ),
      ItineraryDayData(
        dayNumber: 3,
        date: 'Tue, Dec 22',
        title: 'Seongsu-dong (Brooklyn of Seoul)',
        summary: 'Industrial brick architecture, flagship pop-up stores, and specialty bakeries.',
        walkingEstimate: '8,400 steps',
        estimatedCost: '₩38,000 (~RM128)',
        stops: [
          ItineraryPlaceStop(
            id: 's_3_1',
            time: '11:00',
            name: 'Café Onion Seongsu',
            category: 'Bakery',
            categoryIcon: '🥐',
            address: 'Achasan-ro 9-gil, Seongdong-gu, Seoul',
            description: 'Industrial rustic bakery famed for Pandoro powdered sugar mountain bread.',
            duration: '1.5 hours',
            estimatedCost: '₩11,000 (~RM37)',
            distanceToNext: '400m',
            travelMethod: 'Walk',
            rating: 4.6,
            reviewCount: 9200,
            whyRecommended: 'Must visit bakery recommended in Notebook.',
            googleMapsUrl: 'https://maps.google.com/?q=Cafe+Onion+Seongsu+Seoul',
            lat: 37.5445,
            lng: 127.0577,
          ),
        ],
      ),
      ItineraryDayData(
        dayNumber: 4,
        date: 'Wed, Dec 23',
        title: 'Gwangjang Market & Cheonggyecheon Stream',
        summary: 'Bindaetteok mungbean pancakes, mayak gimbap, and night lights.',
        walkingEstimate: '7,500 steps',
        estimatedCost: '₩28,000 (~RM94)',
        stops: [
          ItineraryPlaceStop(
            id: 's_4_1',
            time: '12:00',
            name: 'Gwangjang Food Market',
            category: 'Market',
            categoryIcon: '🥟',
            address: 'Changgyeonggung-ro, Jongno-gu, Seoul',
            description: 'Seoul’s oldest traditional street food market.',
            duration: '2 hours',
            estimatedCost: '₩14,000 (~RM46)',
            distanceToNext: 'Airport bus transfer',
            travelMethod: 'Bus',
            rating: 4.6,
            reviewCount: 32000,
            whyRecommended: 'Classic farewell street food banquet.',
            googleMapsUrl: 'https://maps.google.com/?q=Gwangjang+Market+Seoul',
            lat: 37.5701,
            lng: 126.9997,
            isHighlight: true,
          ),
        ],
      ),
    ];

    final seoulTrip = TripFolderItem(
      id: 'trip_seoul_2026',
      name: 'Seoul Food Trip',
      destination: 'Seoul, South Korea',
      startDate: '20 Dec',
      endDate: '24 Dec 2026',
      startDateTime: DateTime(2026, 12, 20),
      endDateTime: DateTime(2026, 12, 24),
      status: TripStatus.upcoming,
      chatId: 'daniel_direct',
      chatName: 'Daniel',
      travellers: seoulTravellers,
      days: seoulDays,
      placesCount: 14,
      lastUpdated: '1 hour ago',
      notebookDecisionsCount: 3,
      mapPreviewUrl: 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=400',
      themeColor: const Color(0xFF3B82F6),
      recommendations: [],
      aiSuggestions: [
        TripAiSuggestion(
          id: 'sug_seoul_hotel',
          title: 'Confirm Hongdae Boutique Hotel under RM220',
          explanation: 'Daniel located a boutique stay in Hapjeong under RM220/night.',
          sourceNotebookQuote: '"Found a boutique hotel near Hongdae under RM220."',
          proposedChangeDescription: 'Lock in Hapjeong location as trip base.',
          targetDayNumber: 1,
        ),
      ],
    );

    // ------------------------------------------------
    // 3. PENANG WEEKEND (Third Trip Folder)
    // ------------------------------------------------
    final penangTravellers = [
      const TravellerInfo(
        id: 't_ken',
        name: 'Ken',
        avatarLetter: 'K',
        avatarColor: Color(0xFF8B5CF6),
        mbti: 'ISTP',
        interests: ['Hawker Food', 'Heritage Streets', 'Coffee'],
        chatId: 'japan_2026',
        travelStyle: 'Relaxed Explorer',
      ),
      const TravellerInfo(
        id: 't_lisa',
        name: 'Lisa',
        avatarLetter: 'L',
        avatarColor: Color(0xFFF59E0B),
        mbti: 'ESFP',
        interests: ['Street Murals', 'Beach Sunsets', 'Desserts'],
        chatId: null,
        travelStyle: 'Social & Fun',
      ),
      const TravellerInfo(
        id: 't_maya_3',
        name: 'Maya',
        avatarLetter: 'M',
        avatarColor: Color(0xFF10B981),
        mbti: 'ENFP',
        interests: ['Heritage Houses', 'Photography'],
        chatId: 'maya_direct',
        travelStyle: 'Photographer',
      ),
      const TravellerInfo(
        id: 't_you_3',
        name: 'You',
        avatarLetter: 'Y',
        avatarColor: Color(0xFFFF5A5F),
        mbti: 'INFJ',
        interests: ['Char Kway Teow', 'Relaxing'],
        chatId: null,
        travelStyle: 'Foodie',
      ),
    ];

    final penangDays = [
      ItineraryDayData(
        dayNumber: 1,
        date: 'Fri, Jan 5',
        title: 'George Town Heritage Murals & Char Kway Teow',
        summary: 'Armenian Street art, Clan Jetties, and Siam Road wok hei char kway teow.',
        walkingEstimate: '8,100 steps',
        estimatedCost: 'RM45/pax',
        stops: [
          ItineraryPlaceStop(
            id: 'pen_1_1',
            time: '11:00',
            name: 'Armenian Street Heritage Murals',
            category: 'Culture',
            categoryIcon: '🎨',
            address: 'Armenian St, George Town, Penang',
            description: 'Ernest Zacharevic’s Kids on a Bicycle and heritage shophouse art.',
            duration: '1.5 hours',
            estimatedCost: 'Free',
            distanceToNext: '500m',
            travelMethod: 'Walk',
            rating: 4.7,
            reviewCount: 12000,
            whyRecommended: 'Top photo spot for Maya.',
            googleMapsUrl: 'https://maps.google.com/?q=Armenian+Street+Penang',
            lat: 5.4150,
            lng: 100.3370,
            isHighlight: true,
          ),
          ItineraryPlaceStop(
            id: 'pen_1_2',
            time: '13:00',
            name: 'Siam Road Charcoal Char Kway Teow',
            category: 'Food',
            categoryIcon: '🍜',
            address: '82 Siam Rd, George Town, Penang',
            description: 'Michelin Bib Gourmand smoky charcoal wok hei noodles.',
            duration: '1 hour',
            estimatedCost: 'RM12',
            distanceToNext: '1.2 km',
            travelMethod: 'Grab ride',
            rating: 4.6,
            reviewCount: 4200,
            whyRecommended: 'Unanimous flock favorite.',
            googleMapsUrl: 'https://maps.google.com/?q=Siam+Road+Char+Kway+Teow+Penang',
            lat: 5.4158,
            lng: 100.3204,
            isHighlight: true,
          ),
        ],
      ),
      ItineraryDayData(
        dayNumber: 2,
        date: 'Sat, Jan 6',
        title: 'Penang Hill Funicular & Habitat Rainforest',
        summary: 'Panoramic island views, Curtis Crest treetop walk, and cool breezes.',
        walkingEstimate: '6,800 steps',
        estimatedCost: 'RM70/pax',
        stops: [
          ItineraryPlaceStop(
            id: 'pen_2_1',
            time: '10:30',
            name: 'The Habitat Penang Hill',
            category: 'Nature',
            categoryIcon: '🌿',
            address: 'Bukit Bendera, Penang',
            description: '130-million-year-old virgin rainforest canopy walk.',
            duration: '3 hours',
            estimatedCost: 'RM60',
            distanceToNext: 'Funicular ride down',
            travelMethod: 'Funicular',
            rating: 4.8,
            reviewCount: 5400,
            whyRecommended: 'Tranquil canopy nature for relaxed afternoon.',
            googleMapsUrl: 'https://maps.google.com/?q=The+Habitat+Penang+Hill',
            lat: 5.4243,
            lng: 100.2690,
            isHighlight: true,
          ),
        ],
      ),
      ItineraryDayData(
        dayNumber: 3,
        date: 'Sun, Jan 7',
        title: 'Batu Ferringhi Beach & Sunset Café',
        summary: 'Sea breezes, tropical fruit juices, and relaxed coastal farewell.',
        walkingEstimate: '5,400 steps',
        estimatedCost: 'RM35/pax',
        stops: [
          ItineraryPlaceStop(
            id: 'pen_3_1',
            time: '16:00',
            name: 'Bora Bora Beach Bar',
            category: 'Beach & Drinks',
            categoryIcon: '🍹',
            address: 'Batu Ferringhi Beach, Penang',
            description: 'Seaside loungers on the sand with coconut shakes and sunset views.',
            duration: '2 hours',
            estimatedCost: 'RM30',
            distanceToNext: 'Airport transfer',
            travelMethod: 'Grab',
            rating: 4.5,
            reviewCount: 3800,
            whyRecommended: 'Sunset wrap-up on the beach.',
            googleMapsUrl: 'https://maps.google.com/?q=Bora+Bora+Batu+Ferringhi+Penang',
            lat: 5.4746,
            lng: 100.2483,
          ),
        ],
      ),
    ];

    final penangTrip = TripFolderItem(
      id: 'trip_penang_2027',
      name: 'Penang Weekend',
      destination: 'Penang, Malaysia',
      startDate: '5 Jan',
      endDate: '7 Jan 2027',
      startDateTime: DateTime(2027, 1, 5),
      endDateTime: DateTime(2027, 1, 7),
      status: TripStatus.upcoming,
      chatId: 'japan_2026',
      chatName: 'Japan 2026',
      travellers: penangTravellers,
      days: penangDays,
      placesCount: 9,
      lastUpdated: 'Yesterday',
      notebookDecisionsCount: 2,
      mapPreviewUrl: 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=400',
      themeColor: const Color(0xFF10B981),
      recommendations: [],
      aiSuggestions: [],
    );

    return [tokyoTrip, seoulTrip, penangTrip];
  }
}
