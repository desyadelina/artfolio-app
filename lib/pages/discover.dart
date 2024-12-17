import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:artfolio_app/pages/detail_page.dart';
import 'package:artfolio_app/components/appbar.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late Future<List<Map<String, dynamic>>> _portfolioDataFuture;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _portfolioDataFuture = _fetchPortfolioData();
    _loadUserProfileImage();
  }

  Future<void> _loadUserProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .get();
      setState(() {
        _profileImageUrl = userProfile['profileImageUrl'] ?? 'https://via.placeholder.com/100';
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPortfolioData() async {
    final firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore.collection('portfolio').get();

    List<Map<String, dynamic>> portfolioList = querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'user_id': doc['user_id'],
        'title': doc['title'],
        'description': doc['description'],
        'link': doc['link'],
        'images': doc['images'],
      };
    }).toList();

    portfolioList.shuffle();
    return portfolioList;
  }

  void _navigateToDetailPage(Map<String, dynamic> portfolioItem) async {
    DocumentSnapshot userProfile = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(portfolioItem['user_id'])
        .get();

    var userData = userProfile.data() as Map<String, dynamic>?;
    var username = userData?['username'] ?? 'username';
    var profileImageUrl = userData?['profileImageUrl'] ?? 'https://via.placeholder.com/100';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          title: portfolioItem['title'],
          username: username,
          profileImageUrl: profileImageUrl,
          description: portfolioItem['description'],
          imageUrls: List<String>.from(portfolioItem['images']),
          link: portfolioItem['link'],
          portfolioId: portfolioItem['id'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: _profileImageUrl != null
              ? NetworkImage(_profileImageUrl!)
              : AssetImage('assets/images/profile.png') as ImageProvider,
        ),
        actions: [
          Image.asset('assets/images/logo-orange.png', width: 35, height: 31),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _portfolioDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          var portfolioData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                  child: Text(
                    'Discover',
                    style: TextStyle(
                      color: const Color(0xFFFF5307),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Most Recent',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: portfolioData.map((portfolioItem) {
                      return GestureDetector(
                        onTap: () => _navigateToDetailPage(portfolioItem),
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (portfolioItem['images'].isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    portfolioItem['images'].first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                portfolioItem['title'] ?? 'No Title',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('profiles')
                                    .doc(portfolioItem['user_id'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading user');
                                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                                    return const Text('User not found');
                                  }

                                  var userData = snapshot.data!.data() as Map<String, dynamic>?;
                                  var username = userData?['username'] ?? 'username';
                                  var profileImageUrl = userData?['profileImageUrl'] ??
                                      'https://via.placeholder.com/100';

                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundImage: NetworkImage(profileImageUrl),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '@$username',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 15),
                MasonryGridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: portfolioData.length,
                  itemBuilder: (context, index) {
                    var portfolioItem = portfolioData[index];
                    var title = portfolioItem['title'] ?? 'No Title';
                    var images = portfolioItem['images'] as List<dynamic>? ?? [];
                    var userId = portfolioItem['user_id'];

                    return GestureDetector(
                      onTap: () => _navigateToDetailPage(portfolioItem),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (images.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  images.first,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('profiles')
                                  .doc(userId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text('Error loading user');
                                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                                  return const Text('User not found');
                                }

                                var userData = snapshot.data!.data() as Map<String, dynamic>?;
                                var username = userData?['username'] ?? 'username';
                                var profileImageUrl = userData?['profileImageUrl'] ??
                                    'https://via.placeholder.com/100';

                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(profileImageUrl),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '@$username',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
