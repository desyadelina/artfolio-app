import 'package:artfolio_app/components/appbar.dart';
import 'package:artfolio_app/components/button.dart';
import 'package:artfolio_app/pages/detail_page.dart';
import 'package:artfolio_app/pages/edit_portfolio.dart';
import 'package:artfolio_app/services/auth_service.dart';
import 'package:artfolio_app/services/portfolio_service.dart';
import 'package:artfolio_app/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> _profileDataFuture;
  late Future<List<Map<String, dynamic>>> _portfolioDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _fetchProfileData();
    _portfolioDataFuture = _fetchPortfolioData();
  }

  Future<Map<String, dynamic>?> _fetchProfileData() async {
    ProfileService profileService = ProfileService();
    return await profileService.getProfile();
  }

  Future<List<Map<String, dynamic>>> _fetchPortfolioData() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    QuerySnapshot querySnapshot = await firestore
        .collection('portfolio')
        .where('user_id', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'user_id': doc['user_id'],
        'title': doc['title'],
        'description': doc['description'],
        'link': doc['link'],
        'images': doc['images'],
      };
    }).toList();
  }

  Future<void> _deletePortfolio(
      BuildContext context, String portfolioId) async {
    final dbService = DatabaseService();
    try {
      await dbService.deletePortfolio(portfolioId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Portfolio deleted successfully')),
      );
      setState(() {
        _portfolioDataFuture = _fetchPortfolioData();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete portfolio: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String portfolioId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePortfolio(context, portfolioId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final authService = AuthService();
    await authService.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _profileDataFuture,
      builder: (context, profileSnapshot) {
        if (profileSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (profileSnapshot.hasError) {
          return Center(child: Text('Error: ${profileSnapshot.error}'));
        }

        var profileData = profileSnapshot.data;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFF1A1A20),
              appBar: CustomAppBar(
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xDEDEDEDE),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xDEDEDEDE),
                    ),
                    onSelected: (String result) {
                      if (result == 'logout') {
                        _showLogoutConfirmationDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
              body: FutureBuilder<List<Map<String, dynamic>>>(
                future: _portfolioDataFuture,
                builder: (context, portfolioSnapshot) {
                  if (portfolioSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (portfolioSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${portfolioSnapshot.error}'));
                  } else if (!portfolioSnapshot.hasData ||
                      portfolioSnapshot.data!.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }

                  var portfolioData = portfolioSnapshot.data!;
                  final currentUser = FirebaseAuth.instance.currentUser;

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF040207),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                                height:
                                    60), // Moved avatar to Positioned widget
                            Text(
                              profileData?['displayName'] ?? 'Display Name',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${profileData?['username'] ?? 'username'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profileData?['description'] ??
                                  'This is a description.',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              buttonText: 'Edit Profile',
                              onPressed: () {
                                Navigator.pushNamed(context, '/editProfile');
                              },
                              width: 92,
                              height: 35,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: MasonryGridView.builder(
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: portfolioData.length,
                            itemBuilder: (context, index) {
                              var portfolioItem = portfolioData[index];
                              var title = portfolioItem['title'] ?? 'No Title';
                              var images =
                                  portfolioItem['images'] as List<dynamic>? ??
                                      [];
                              var isOwner =
                                  portfolioItem['user_id'] == currentUser?.uid;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        title: portfolioItem['title'],
                                        username: profileData?['username'] ??
                                            'username',
                                        profileImageUrl: profileData?[
                                                'profileImageUrl'] ??
                                            'https://via.placeholder.com/100',
                                        description:
                                            portfolioItem['description'],
                                        imageUrls: images.cast<String>(),
                                        link: portfolioItem['link'],
                                        portfolioId: portfolioItem['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (images.isNotEmpty)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            images.first,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Text(
                                                title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_horiz_rounded,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            onSelected: (String result) {
                                              switch (result) {
                                                case 'edit':
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditPortfolioPage(
                                                        portfolioId:
                                                            portfolioItem['id'],
                                                        portfolioData:
                                                            portfolioItem,
                                                      ),
                                                    ),
                                                  ).then((result) {
                                                    if (result == 'updated') {
                                                      setState(() {
                                                        _portfolioDataFuture =
                                                            _fetchPortfolioData();
                                                      });
                                                    }
                                                  });
                                                  break;
                                                case 'delete':
                                                  _showDeleteConfirmationDialog(
                                                      context,
                                                      portfolioItem['id']);
                                                  break;
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              if (isOwner)
                                                const PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: Text('Edit'),
                                                ),
                                              if (isOwner)
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Text('Delete'),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 40,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                backgroundImage: profileData?['profileImageUrl'] != null
                    ? NetworkImage(profileData!['profileImageUrl'])
                    : const NetworkImage('https://via.placeholder.com/100'),
              ),
            ),
          ],
        );
      },
    );
  }
}
