// // import 'package:flutter/material.dart';
// // import 'package:artfolio_app/components/navbar.dart';
// // import 'package:artfolio_app/pages/discover.dart';
// // import 'package:artfolio_app/pages/explore.dart';
// // import 'package:artfolio_app/pages/upload.dart';
// // import 'package:artfolio_app/pages/profile.dart';

// // class Index extends StatefulWidget {
// //   const Index({Key? key}) : super(key: key);

// //   @override
// //   _IndexState createState() => _IndexState();
// // }

// // class _IndexState extends State<Index> {
// //   int _currentIndex = 0;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _getPage(_currentIndex),
// //       bottomNavigationBar: BottomNavBar(
// //         currentIndex: _currentIndex,
// //         onTap: (index) {
// //           setState(() {
// //             _currentIndex = index;
// //           });
// //         },
// //       ),
// //     );
// //   }

// //   Widget _getPage(int index) {
// //     switch (index) {
// //       case 0:
// //         return const DiscoverPage();
// //       case 1:
// //         return const ExplorePage();
// //       case 2:
// //         return const UploadPage();
// //       case 3:
// //         return const ProfilePage();
// //       default:
// //         return const DiscoverPage();
// //     }
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:artfolio_app/components/navbar.dart';
// import 'package:artfolio_app/pages/discover.dart';
// import 'package:artfolio_app/pages/explore.dart';
// import 'package:artfolio_app/pages/upload.dart';
// import 'package:artfolio_app/pages/profile.dart';

// class Index extends StatefulWidget {
//   final int initialIndex;

//   const Index({Key? key, this.initialIndex = 0}) : super(key: key);

//   @override
//   _IndexState createState() => _IndexState();
// }

// class _IndexState extends State<Index> {
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _getPage(_currentIndex),
//       bottomNavigationBar: BottomNavBar(
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         currentIndex: _currentIndex,
//       ),
//     );
//   }

//   Widget _getPage(int index) {
//     switch (index) {
//       case 0:
//         return const DiscoverPage();
//       case 1:
//         return const ExplorePage();
//       case 2:
//         return const UploadPage();
//       case 3:
//         return const ProfilePage();
//       default:
//         return const DiscoverPage();
//     }
//   }
// }










import 'package:flutter/material.dart';
import 'package:artfolio_app/components/navbar.dart';
import 'package:artfolio_app/pages/discover.dart';
import 'package:artfolio_app/pages/explore.dart';
import 'package:artfolio_app/pages/upload.dart';
import 'package:artfolio_app/pages/profile.dart';

class Index extends StatefulWidget {
  final int initialIndex;

  const Index({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DiscoverPage();
      case 1:
        return const ExplorePage();
      case 2:
        return const UploadPage();
      case 3:
        return const ProfilePage();
      default:
        return const DiscoverPage();
    }
  }
}
