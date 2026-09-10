import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';

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

  void _showWriteJournalDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Write Daily Journal'),
        content: const TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'What did you enjoy today? (Helps AI improve future matches)',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Journal saved! Earned +50 TripCoins 🔥')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
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
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _showWriteJournalDialog,
      icon: const Icon(Icons.edit),
      label: const Text('Daily Journal'),
      backgroundColor: coral,
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
