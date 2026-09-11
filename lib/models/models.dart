enum PostVisibility { public, friendsOnly }

class TripData {
  String name = 'Trip to Japan';
  String destination = 'Japan';
  String startDate = 'Apr 12, 2026';
  String endDate = 'Apr 22, 2026';
  bool soloMatching = false;
  final List<String> collaborators = [];
  final List<String> places = [
    'Narisawa',
    'Den',
    'Ise Sueyoshi',
    'Teppan Baby',
  ];
  final List<String> notes = [];
  final List<String> expenses = [];
  // TripNest New Feature Lists
  final List<String> chatMessages = [];
  final List<String> notebookItems = [];
}

class JournalPost {
  final String owner;
  final String tripName;
  final String dates;
  final String caption;
  final String location;
  final String image;
  PostVisibility visibility;

  JournalPost({
    required this.owner,
    required this.tripName,
    required this.dates,
    required this.caption,
    required this.location,
    required this.image,
    this.visibility = PostVisibility.public,
  });
}

class FriendRequest {
  final String username;
  String status;
  final String? message;
  FriendRequest(this.username, {this.status = 'Pending', this.message});
}

class MatchRequest {
  final String username;
  final TripData trip;
  String status;
  final String? note;
  MatchRequest(this.username, this.trip, {this.status = 'Pending', this.note});
}

// Mock User Profile data for TripNest
class UserProfile {
  String username;
  String name;
  int age;
  bool verified;
  bool isOpenToPair;
  String mbti;
  List<String> interests;
  String budgetStyle;
  String travelPace;
  String walkingTolerance;
  String dailyRhythm;
  String destinationVibe;
  String planningStyle;
  String preferredDestination; // e.g. 'Kyoto, Japan', 'Tokyo, Japan', or 'Unknown'
  String preferredDateRange; // e.g. 'Oct 12 - Oct 20, 2026' or 'Unknown'
  String? avatarUrl;
  String? instagram;
  String? xHandle;
  int compatibilityScore;
  int reliabilityScore;

  UserProfile({
    required this.username,
    required this.name,
    required this.age,
    this.verified = true,
    this.isOpenToPair = true,
    this.mbti = 'ENFP',
    this.interests = const [],
    this.budgetStyle = 'Budget Explorer',
    this.travelPace = 'Relaxed',
    this.walkingTolerance = '15,000 Steps/Day',
    this.dailyRhythm = 'Early Riser',
    this.destinationVibe = 'Vibrant City',
    this.planningStyle = 'Spontaneous',
    this.preferredDestination = 'Unknown',
    this.preferredDateRange = 'Unknown',
    this.avatarUrl,
    this.instagram,
    this.xHandle,
    this.compatibilityScore = 0,
    this.reliabilityScore = 100,
  });
}

class SocialData {
  final String currentUsername = 'benwander';
  final List<String> friends = ['mayaexplores'];
  final List<FriendRequest> friendRequests = [
    FriendRequest(
      'annatravel',
      message: 'Hey Ben! Saw your Kyoto itinerary. Would love to connect and share travel recommendations!',
    ),
  ];
  final List<MatchRequest> matchRequests = [];
  
  UserProfile myProfile = UserProfile(
    username: 'benwander',
    name: 'Ben',
    age: 24,
    verified: false, // Starts unverified so ID verification flow triggers on first login
    isOpenToPair: true,
    mbti: 'INTJ',
    interests: ['Photography', 'Foodie'],
    preferredDestination: 'Unknown',
    preferredDateRange: 'Unknown',
    avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500',
  );

  final List<UserProfile> potentialMatches = [
    UserProfile(
      username: 'mayaexplores',
      name: 'Maya',
      age: 23,
      verified: true,
      isOpenToPair: true,
      mbti: 'ENFP',
      interests: ['Café Hopping', 'Photography', 'Art'],
      budgetStyle: 'Budget Explorer',
      travelPace: 'Balanced Pace',
      walkingTolerance: '15,000 Steps/Day',
      preferredDestination: 'Kyoto, Japan',
      preferredDateRange: 'Apr 12 - Apr 22, 2026',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
      compatibilityScore: 94,
      reliabilityScore: 98,
    ),
    UserProfile(
      username: 'alex_globetrotter',
      name: 'Alex',
      age: 25,
      verified: true,
      isOpenToPair: true,
      mbti: 'INFJ',
      interests: ['Museums', 'Local Markets', 'History'],
      budgetStyle: 'Comfortable',
      travelPace: 'Relaxed',
      walkingTolerance: '12,000 Steps/Day',
      preferredDestination: 'Rome, Italy', // Fixed Destination
      preferredDateRange: 'May 01 - May 10, 2026', // Fixed Date
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
      compatibilityScore: 88,
      reliabilityScore: 95,
    ),
    UserProfile(
      username: 'sam_wanders',
      name: 'Sam',
      age: 27,
      verified: true,
      isOpenToPair: true,
      mbti: 'ENTP',
      interests: ['Foodie', 'Nightlife', 'Photography'],
      budgetStyle: 'Luxury',
      travelPace: 'Packed Itinerary',
      walkingTolerance: '20,000 Steps/Day',
      preferredDestination: 'Tokyo, Japan', // Fixed Destination
      preferredDateRange: 'Unknown', // Flexible Date
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500',
      compatibilityScore: 82,
      reliabilityScore: 91,
    ),
    UserProfile(
      username: 'johndoe',
      name: 'John',
      age: 26,
      verified: true,
      isOpenToPair: true,
      mbti: 'ISTP',
      interests: ['Nature', 'Hiking', 'Street Food'],
      budgetStyle: 'Comfortable',
      travelPace: 'Packed Itinerary',
      walkingTolerance: '25,000 Steps/Day',
      preferredDestination: 'Unknown',
      preferredDateRange: 'Unknown',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500',
      compatibilityScore: 68,
      reliabilityScore: 85,
    ),
    UserProfile(
      username: 'lisa_quiet',
      name: 'Lisa',
      age: 22,
      verified: true,
      isOpenToPair: false, // Closed to pair
      mbti: 'ISFP',
      interests: ['Reading', 'Parks'],
      budgetStyle: 'Budget Explorer',
      travelPace: 'Slow Motion',
      avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500',
      compatibilityScore: 75,
      reliabilityScore: 90,
    ),
  ];

  final List<JournalPost> posts = [
    JournalPost(
      owner: 'mayaexplores',
      tripName: 'Weekend in Kyoto',
      dates: 'May 2 - May 6',
      caption: 'Quiet streets, tiny coffee shops, and the best ramen of the trip.',
      location: 'Kyoto, Japan',
      image: 'photo-1493976040374-85c8e12f0c0e',
    ),
    JournalPost(
      owner: 'annatravel',
      tripName: 'Tokyo Food Notes',
      dates: 'Apr 12 - Apr 22',
      caption: 'Saving every place I want to revisit on my next Japan trip.',
      location: 'Tokyo, Japan',
      image: 'photo-1540959733332-eab4deabeeaf',
      visibility: PostVisibility.friendsOnly,
    ),
  ];

  bool isFriend(String username) => friends.contains(username);
}
