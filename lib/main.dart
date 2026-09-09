import 'package:flutter/material.dart';

void main() => runApp(const TripNestApp());

const coral = Color(0xffff5c4d);

class TripNestApp extends StatelessWidget {
  const TripNestApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TripNest',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: coral),
      scaffoldBackgroundColor: const Color(0xfff8f9fa),
      fontFamily: 'Arial',
      useMaterial3: true,
    ),
    home: const AuthGate(),
  );
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool signUp = true;
  final email = TextEditingController();
  final password = TextEditingController();

  void enterApp() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeShell()),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TripNest',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: coral,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 42),
            Text(
              signUp ? 'Plan your next adventure' : 'Welcome back',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              signUp
                  ? 'Create an account and make every trip count.'
                  : 'Sign in to continue planning your trips.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 32),
            field('Email address', Icons.mail_outline, email),
            const SizedBox(height: 14),
            field('Password', Icons.lock_outline, password, obscure: true),
            if (signUp) ...[
              const SizedBox(height: 14),
              field('Your name', Icons.person_outline, TextEditingController()),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: enterApp,
                style: FilledButton.styleFrom(
                  backgroundColor: coral,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  signUp ? 'Create account' : 'Sign in',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: TextStyle(color: Colors.grey)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: enterApp,
                icon: const Text(
                  'G',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: TextButton(
                onPressed: () => setState(() => signUp = !signUp),
                child: Text(
                  signUp
                      ? 'Already have an account? Sign in'
                      : 'New to TripNest? Create an account',
                  style: const TextStyle(
                    color: coral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget field(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool obscure = false,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );
}

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
}

enum PostVisibility { public, friendsOnly }

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

class SocialData {
  final String currentUsername = 'benwander';
  final List<String> friends = ['mayaexplores'];
  final List<FriendRequest> friendRequests = [FriendRequest('annatravel')];
  final List<MatchRequest> matchRequests = [];
  final List<JournalPost> posts = [
    JournalPost(
      owner: 'mayaexplores',
      tripName: 'Weekend in Kyoto',
      dates: 'May 2 - May 6',
      caption:
          'Quiet streets, tiny coffee shops, and the best ramen of the trip.',
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
    JournalPost(
      owner: 'cityatlas',
      tripName: 'A week in New York',
      dates: 'Jun 8 - Jun 15',
      caption: 'A little itinerary inspiration for first-time visitors.',
      location: 'New York, USA',
      image: 'photo-1485871981521-5b1fd3805eee',
    ),
    JournalPost(
      owner: 'benwander',
      tripName: 'Trip to Japan',
      dates: 'Apr 12 - Apr 22',
      caption: 'Building out my Japan itinerary one great meal at a time.',
      location: 'Japan',
      image: 'photo-1493976040374-85c8e12f0c0e',
    ),
  ];

  bool isFriend(String username) => friends.contains(username);
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selected = 0;
  bool tripDetailOpen = false;
  bool tripsListOpen = false;
  final trip = TripData();
  final social = SocialData();

  void openTrip() => setState(() {
    selected = 0;
    tripDetailOpen = true;
    tripsListOpen = false;
  });

  void openTripsList() => setState(() {
    selected = 0;
    tripDetailOpen = false;
    tripsListOpen = true;
  });

  void createTrip(String name, String destination) {
    setState(() {
      trip.name = name;
      trip.destination = destination;
      selected = 0;
      tripDetailOpen = true;
      tripsListOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      tripDetailOpen
          ? TripScreen(
              trip: trip,
              onBack: () => setState(() => tripDetailOpen = false),
            )
          : tripsListOpen
          ? TripsPage(trip: trip, onOpenTrip: openTrip)
          : HomeFeed(trip: trip, onOpenTrip: openTrip, onSeeAll: openTripsList),
      SocialPage(data: social),
      CreateTripPage(onCreate: createTrip),
      ProfilePage(data: social, trip: trip, onChanged: () => setState(() {})),
    ];
    return Scaffold(
      body: pages[selected],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) => setState(() {
          selected = index;
          if (index == 0) {
            tripDetailOpen = false;
            tripsListOpen = false;
          }
        }),
        indicatorColor: const Color(0xffffe2de),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Social',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeFeed extends StatelessWidget {
  final TripData trip;
  final VoidCallback onOpenTrip;
  final VoidCallback onSeeAll;
  const HomeFeed({
    super.key,
    required this.trip,
    required this.onOpenTrip,
    required this.onSeeAll,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Text(
                    'TripNest',
                    style: TextStyle(
                      fontSize: 24,
                      color: coral,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  roundIcon(Icons.search),
                  const SizedBox(width: 8),
                  roundIcon(
                    Icons.workspace_premium,
                    color: const Color(0xffffb84d),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Continue planning',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  TextButton(
                    onPressed: onSeeAll,
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xff3779db),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: InkWell(
                onTap: onOpenTrip,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=200',
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${trip.destination}     ${trip.places.length} places',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 28),
              height: 290,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1496588152823-86ff7695e68f?w=800',
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black38),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Get inspired for\nyour trip to New\nYork City',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1.08,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(backgroundColor: coral),
                      child: const Text('Explore guides'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Featured guides from users',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  guide('Tokyo food tour', 'photo-1540959733332-eab4deabeeaf'),
                  guide('A weekend in NYC', 'photo-1485871981521-5b1fd3805eee'),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget roundIcon(IconData icon, {Color? color}) => CircleAvatar(
  radius: 17,
  backgroundColor: Colors.grey.shade100,
  child: Icon(icon, size: 19, color: color ?? Colors.grey.shade700),
);

class SocialPage extends StatefulWidget {
  final SocialData data;
  const SocialPage({super.key, required this.data});
  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  List<JournalPost> get visiblePosts => widget.data.posts
      .where(
        (post) =>
            post.visibility == PostVisibility.public ||
            widget.data.isFriend(post.owner) ||
            post.owner == widget.data.currentUsername,
      )
      .toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Social',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          tooltip: 'Search posts',
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const Text(
          'Travel journals from your people',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Public posts and friends-only updates you can see.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        ...visiblePosts.map((post) => journalCard(post)),
      ],
    ),
  );

  Widget journalCard(JournalPost post) => Card(
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://images.unsplash.com/${post.image}?w=900',
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xffffe2de),
                    child: Text(
                      post.owner.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: coral,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      post.owner,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    post.visibility == PostVisibility.public
                        ? 'Public'
                        : 'Friends only',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.tripName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${post.dates} · ${post.location}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(post.caption),
              if (post.owner == widget.data.currentUsername) ...[
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Post visibility',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: post.visibility == PostVisibility.public,
                      onChanged: (value) => setState(
                        () => post.visibility = value
                            ? PostVisibility.public
                            : PostVisibility.friendsOnly,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

Widget guide(String title, String image) => Container(
  width: 150,
  margin: const EdgeInsets.only(right: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 5)],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        child: Image.network(
          'https://images.unsplash.com/$image?w=300',
          height: 88,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    ],
  ),
);

class TripsPage extends StatelessWidget {
  final TripData trip;
  final VoidCallback onOpenTrip;
  const TripsPage({super.key, required this.trip, required this.onOpenTrip});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Your trips',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          tooltip: 'Search trips',
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Plan and revisit your adventures',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 18),
        InkWell(
          onTap: onOpenTrip,
          borderRadius: BorderRadius.circular(14),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${trip.destination} · ${trip.places.length} places',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.archive_outlined),
          label: const Text('Archived trips'),
        ),
      ],
    ),
  );
}

class TripScreen extends StatefulWidget {
  final TripData trip;
  final VoidCallback onBack;
  const TripScreen({super.key, required this.trip, required this.onBack});
  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      OverviewTab(trip: widget.trip),
      PlacesTab(trip: widget.trip),
      BudgetTab(trip: widget.trip),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.trip.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to trips',
        ),
        actions: const [Icon(Icons.ios_share), SizedBox(width: 14)],
        bottom: TripTabs(
          selected: tab,
          onSelect: (value) => setState(() => tab = value),
        ),
      ),
      body: screens[tab],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff20252b),
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    final label = tab == 2 ? 'Expense name' : 'Place name';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add ${tab == 2 ? 'expense' : 'place'}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  if (tab == 2) {
                    widget.trip.expenses.add(controller.text.trim());
                  } else {
                    widget.trip.places.add(controller.text.trim());
                  }
                });
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class TripTabs extends StatelessWidget implements PreferredSizeWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const TripTabs({super.key, required this.selected, required this.onSelect});
  @override
  Size get preferredSize => const Size.fromHeight(42);
  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Row(
      children: ['Overview', 'Places', 'Budget', 'Journal']
          .asMap()
          .entries
          .map(
            (entry) => Expanded(
              child: InkWell(
                onTap: () => onSelect(entry.key > 2 ? 0 : entry.key),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 11,
                        color: selected == entry.key
                            ? coral
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 2,
                      color: selected == entry.key ? coral : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class OverviewTab extends StatefulWidget {
  final TripData trip;
  const OverviewTab({super.key, required this.trip});
  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(12),
    children: [
      Text(
        widget.trip.name,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      Text(
        '${widget.trip.startDate} - ${widget.trip.endDate}',
        style: TextStyle(color: Colors.grey.shade600),
      ),
      const SizedBox(height: 14),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solo matching',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Let other solo travellers ask to join this trip',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.trip.soloMatching,
                onChanged: (value) =>
                    setState(() => widget.trip.soloMatching = value),
              ),
            ],
          ),
        ),
      ),
      stepCard(
        'Explore things to do',
        'Add places from popular blogs',
        'Explore',
      ),
      const SizedBox(height: 18),
      const Text(
        'Reservations and attachments',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icons.flight,
          Icons.hotel,
          Icons.train,
          Icons.attach_file,
        ].map((icon) => Icon(icon, color: Colors.grey.shade700)).toList(),
      ),
      const Divider(height: 32),
      const Text(
        'Notes',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Text(
        'Write or paste general notes here, e.g. how to get around, local tips, reminders',
        style: TextStyle(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );
}

Widget stepCard(String title, String subtitle, String action) => Card(
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xff3779db),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ),
);

class PlacesTab extends StatelessWidget {
  final TripData trip;
  const PlacesTab({super.key, required this.trip});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(12),
    children: [
      const Text(
        'Places to visit',
        style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 10),
      ...trip.places.asMap().entries.map(
        (entry) => Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 13,
              backgroundColor: const Color(0xffe9efff),
              child: Text(
                '${entry.key + 1}',
                style: const TextStyle(
                  color: Color(0xff315fca),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              entry.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Closed Sun, Mon\nJapanese restaurant'),
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=140',
                width: 60,
                height: 58,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class BudgetTab extends StatelessWidget {
  final TripData trip;
  const BudgetTab({super.key, required this.trip});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        color: const Color(0xff26345b),
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: const Column(
          children: [
            Text(
              'MYR 0.00',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text('Set a budget', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              trip.expenses.isEmpty
                  ? 'You haven\'t added any expenses yet. Track your spending and split costs by adding an expense.'
                  : '${trip.expenses.length} expense(s) added to this trip.',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 220),
            Center(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add expense'),
                style: FilledButton.styleFrom(backgroundColor: coral),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class CreateTripPage extends StatefulWidget {
  final void Function(String name, String destination) onCreate;
  const CreateTripPage({super.key, required this.onCreate});
  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final nameController = TextEditingController();
  final destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Create a trip',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Start planning somewhere new',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Add the basics now. You can fill in places, reservations, and expenses later.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Trip name',
            hintText: 'Summer in Japan',
            prefixIcon: Icon(Icons.luggage_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: destinationController,
          decoration: const InputDecoration(
            labelText: 'Destination',
            hintText: 'Tokyo, Japan',
            prefixIcon: Icon(Icons.place_outlined),
          ),
        ),
        const SizedBox(height: 26),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: () {
              final name = nameController.text.trim();
              final destination = destinationController.text.trim();
              if (name.isEmpty || destination.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add a trip name and destination first.'),
                  ),
                );
                return;
              }
              widget.onCreate(name, destination);
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Build this trip'),
            style: FilledButton.styleFrom(backgroundColor: coral),
          ),
        ),
      ],
    ),
  );
}

class ProfilePage extends StatefulWidget {
  final SocialData data;
  final TripData trip;
  final VoidCallback onChanged;
  const ProfilePage({
    super.key,
    required this.data,
    required this.trip,
    required this.onChanged,
  });
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final searchController = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    final normalizedSearch = search.trim().toLowerCase();
    final searchResult =
        normalizedSearch.isEmpty || !'annatravel'.contains(normalizedSearch)
        ? null
        : 'annatravel';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: Color(0xffffe2de),
            child: Icon(Icons.person, size: 42, color: coral),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              '@benwander',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Find friends',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() => search = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search by username',
            ),
          ),
          if (searchResult != null)
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Text('A')),
                title: const Text('@annatravel'),
                subtitle: const Text('Travel photographer'),
                trailing: _friendAction(searchResult),
              ),
            ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Friend requests',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.data.friendRequests.length}',
                style: const TextStyle(
                  color: coral,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...widget.data.friendRequests.map(
            (request) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Text('A')),
                title: Text('@${request.username}'),
                subtitle: Text(request.status),
                trailing: request.status == 'Pending'
                    ? Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            onPressed: () => acceptFriend(request),
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: 'Accept',
                          ),
                          IconButton(
                            onPressed: () => declineFriend(request),
                            icon: const Icon(Icons.close, color: Colors.red),
                            tooltip: 'Decline',
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Friends (${widget.data.friends.length})',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          ...widget.data.friends.map(
            (friend) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('@$friend'),
            ),
          ),
          if (widget.data.matchRequests.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text(
              'Solo match requests',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            ...widget.data.matchRequests.map(
              (request) => Card(
                child: ListTile(
                  title: Text('@${request.username} wants to join'),
                  subtitle: Text(
                    '${request.trip.name} · ${request.trip.destination}',
                  ),
                  trailing: FilledButton(
                    onPressed: () => acceptMatch(request),
                    child: const Text('Accept'),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _friendAction(String username) {
    final matches = widget.data.friendRequests
        .where((item) => item.username == username)
        .toList();
    final request = matches.isEmpty ? null : matches.first;
    if (widget.data.isFriend(username)) {
      return const Text('Friends', style: TextStyle(color: Colors.green));
    }
    return FilledButton(
      onPressed: request?.status == 'Pending'
          ? null
          : () {
              setState(
                () => widget.data.friendRequests.add(FriendRequest(username)),
              );
              widget.onChanged();
            },
      child: Text(request?.status == 'Pending' ? 'Pending' : 'Add friend'),
    );
  }

  void acceptFriend(FriendRequest request) {
    setState(() {
      request.status = 'Accepted';
      widget.data.friends.add(request.username);
      widget.data.friendRequests.remove(request);
    });
    widget.onChanged();
    if (widget.trip.soloMatching) {
      final match = MatchRequest(request.username, widget.trip);
      setState(() => widget.data.matchRequests.add(match));
      _showMatchPopup(match);
    }
  }

  void declineFriend(FriendRequest request) =>
      setState(() => widget.data.friendRequests.remove(request));

  void _showMatchPopup(MatchRequest match) => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Solo matching request'),
      content: Text(
        'Hey! I\'m looking for travel buddies for my upcoming trip in ${match.trip.destination} from ${match.trip.startDate} to ${match.trip.endDate}. Want to join?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            match.status = 'Declined';
            widget.data.matchRequests.remove(match);
            Navigator.pop(dialogContext);
            setState(() {});
          },
          child: const Text('Decline'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            acceptMatch(match);
          },
          child: const Text('Accept match'),
        ),
      ],
    ),
  );

  void acceptMatch(MatchRequest match) {
    setState(() {
      match.status = 'Accepted';
      widget.data.matchRequests.remove(match);
      if (!match.trip.collaborators.contains(match.username)) {
        match.trip.collaborators.add(match.username);
      }
    });
    widget.onChanged();
  }
}
