import 'dart:async';
import 'package:artfolio_app/components/input.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String username;
  final String profileImageUrl;
  final String description;
  final List<String> imageUrls;
  final String link;
  final String portfolioId;

  DetailPage({
    required this.title,
    required this.username,
    required this.profileImageUrl,
    required this.description,
    required this.imageUrls,
    required this.link,
    required this.portfolioId,
  });

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF040207),
      appBar: AppBar(
        backgroundColor: Color(0xFF040207),
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xDEDEDEDE)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSlider(context),
                SizedBox(height: 13),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '@$username',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xDEDEDEDE),
                  ),
                ),
                SizedBox(height: 4),
                _buildLink(),
                SizedBox(height: 22),
                Divider(color: Color.fromARGB(29, 222, 222, 222), thickness: 1),
                SizedBox(height: 22),
                _buildInteractionsSection(),
                SizedBox(height: 22),
                _buildCommentsList(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Color(0xFF040207),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomInput(
                      placeholder: 'Add a comment...',
                      icon: Icons.comment,
                      iconColor: Colors.white.withOpacity(0.6),
                      controller: _commentController,
                      width: double.infinity,
                      height: 50,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFFF5307)),
                    onPressed: () => _addComment(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxWidth;
        return CarouselSlider(
          options: CarouselOptions(
            height: 400,
            viewportFraction: 1.0,
            enableInfiniteScroll: imageUrls.length > 1,
            autoPlay: imageUrls.length > 1,
          ),
          items: imageUrls.map((imageUrl) {
            return FutureBuilder<double>(
              future: _getImageAspectRatio(imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final aspectRatio = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<double> _getImageAspectRatio(String imageUrl) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    final size = await completer.future;
    return size.width / size.height;
  }

  Widget _buildLink() {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(link);
        if (await canLaunch(uri.toString())) {
          await launch(uri.toString());
        } else {
          throw 'Could not launch $link';
        }
      },
      child: Row(
        children: [
          Icon(Icons.link, size: 15, color: Colors.white.withOpacity(0.5)),
          SizedBox(width: 6),
          Text(
            link,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Interactions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to interactions page
              },
              child: Text(
                'See more',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF5307),
                ),
              ),
            ),
          ],
        ),
        // Add interactions content here
      ],
    );
  }

  Future<void> _addComment() async {
    if (_commentController.text.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(user.uid)
            .get();
        String? displayName = userData['displayName'];
        String? profileImageUrl = userData['profileImageUrl'];

        await FirebaseFirestore.instance.collection('comments').add({
          'text': _commentController.text,
          'userId': user.uid,
          'username': displayName ?? 'Anonymous',
          'profileImageUrl':
              profileImageUrl ?? 'https://via.placeholder.com/150',
          'portfolioId': portfolioId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _commentController.clear();
      }
    }
  }

  Widget _buildCommentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('portfolioId', isEqualTo: portfolioId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Not found',
              style: TextStyle(color: Color.fromARGB(71, 255, 255, 255), fontSize: 12),
            ),
          );
        } else {
          var comments = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              var comment = comments[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(comment['profileImageUrl']),
                ),
                title: Text(
                  comment['username'],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  comment['text'],
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              );
            },
          );
        }
      },
    );
  }
}
