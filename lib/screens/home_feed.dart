import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/models.dart';

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
                      Expanded(
                        child: Column(
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
                      ),
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
