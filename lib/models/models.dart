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
  FriendRequest(this.username, {this.status = 'Pending'});
}

class MatchRequest {
  final String username;
  final TripData trip;
  String status;
  MatchRequest(this.username, this.trip, {this.status = 'Pending'});
}

// Mock User Profile data for TripNest
class UserProfile {
  String username;
  String name;
  int age;
  bool verified;
  String mbti;
  List<String> interests;
  String budgetStyle;
  String travelPace;
  String walkingTolerance;
  String dailyRhythm;
  String destinationVibe;
  String planningStyle;
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
    this.mbti = 'ENFP',
    this.interests = const [],
    this.budgetStyle = 'Budget Explorer',
    this.travelPace = 'Relaxed',
    this.walkingTolerance = '15,000 Steps/Day',
    this.dailyRhythm = 'Early Riser',
    this.destinationVibe = 'Vibrant City',
    this.planningStyle = 'Spontaneous',
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
  final List<FriendRequest> friendRequests = [FriendRequest('annatravel')];
  final List<MatchRequest> matchRequests = [];
  
  UserProfile myProfile = UserProfile(
    username: 'benwander',
    name: 'Ben',
    age: 24,
    mbti: 'INTJ',
    interests: ['Photography', 'Foodie'],
  );

  final List<UserProfile> potentialMatches = [
    UserProfile(
      username: 'mayaexplores',
      name: 'Maya',
      age: 23,
      mbti: 'ENFP',
      interests: ['Café Hopping', 'Photography', 'Art'],
      budgetStyle: 'Budget Traveller',
      travelPace: 'Balanced Pace',
      walkingTolerance: '15,000 Steps/Day',
      compatibilityScore: 91,
      reliabilityScore: 98,
    ),
    UserProfile(
      username: 'johndoe',
      name: 'John',
      age: 26,
      mbti: 'ISTP',
      interests: ['Nature', 'Hiking', 'Street Food'],
      budgetStyle: 'Comfortable',
      travelPace: 'Packed Itinerary',
      walkingTolerance: '25,000 Steps/Day',
      compatibilityScore: 64,
      reliabilityScore: 85,
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
