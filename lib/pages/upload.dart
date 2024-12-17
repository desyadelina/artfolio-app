import 'dart:typed_data';
import 'package:artfolio_app/components/appbar.dart';
import 'package:artfolio_app/components/button.dart';
import 'package:artfolio_app/pages/form_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _selectedAlbum;
  List<AssetEntity> _images = [];
  List<AssetEntity> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _loadAlbums();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission required'),
            content:
                Text('This app needs storage access to function properly.'),
            actions: <Widget>[
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _loadAlbums() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    setState(() {
      _albums = albums;
      _selectedAlbum = _albums.isNotEmpty ? _albums[0] : null;
      if (_selectedAlbum != null) {
        _loadImages();
      }
    });
  }

  Future<void> _loadImages() async {
    if (_selectedAlbum == null) return;
    final List<AssetEntity> photos = await _selectedAlbum!.getAssetListRange(
      start: 0,
      end: 100,
    );
    setState(() {
      _images = photos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 20),
                DropdownButton<AssetPathEntity>(
                  value: _selectedAlbum,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                  underline: const SizedBox(),
                  items: _albums.map((AssetPathEntity album) {
                    return DropdownMenuItem<AssetPathEntity>(
                      value: album,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            album.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (AssetPathEntity? newValue) {
                    setState(() {
                      _selectedAlbum = newValue!;
                      _loadImages();
                    });
                  },
                ),
              ],
            ),
          ),
          CustomButton(
            buttonText: 'Next',
            onPressed: _selectedImages.isNotEmpty
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormUploadPage(
                          selectedImages: _selectedImages,
                        ),
                      ),
                    );
                  }
                : () {},
            width: 60,
            height: 60,
            isCircular: true,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedImages.contains(_images[index])) {
                          _selectedImages.remove(_images[index]);
                        } else {
                          if (_selectedImages.length < 4) {
                            _selectedImages.add(_images[index]);
                          }
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        FutureBuilder<Uint8List?>(
                          future: _images[index].thumbnailDataWithSize(
                            const ThumbnailSize(100, 100),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                        if (_selectedImages.contains(_images[index]))
                          Positioned(
                            right: 5,
                            top: 5,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFFF5307),
                              radius: 12,
                              child: Text(
                                '${_selectedImages.indexOf(_images[index]) + 1}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(32, 255, 255, 255),
                    width: 1.0,
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 13.0),
                color: Colors.black12,
                height: 122,
                child: _selectedImages.isEmpty
                    ? const Center(
                        child: Text(
                          'No selected attachment. Max 4 items',
                          style: TextStyle(
                              color: Color.fromARGB(62, 255, 255, 255)),
                        ),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 5);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FutureBuilder<Uint8List?>(
                              future: _selectedImages[index]
                                  .thumbnailDataWithSize(
                                      const ThumbnailSize(100, 100)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.memory(
                                      snapshot.data!,
                                      width: 90,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
