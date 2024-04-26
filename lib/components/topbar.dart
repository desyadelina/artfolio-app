// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class MyTopBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? leadingIcon;
  final String? leadingImage;
  final IconData? trailingIcon;
  final String? trailingImage;
  final Function()? leadingAction;
  final Function()? trailingAction;
  final bool isBackButton;
  final bool isAvatar;
  final bool isSearch;
  final bool isFolderDropdown;
  final bool isNextButton;
  final bool isThreeDot;
  final bool isExplore;
  final bool isDiscover;
  final bool isUpload;
  final bool isMyProfile;
  final bool isProfileOtherUser;
  final bool isDescriptionPortfolio;
  final bool isDescriptionPortfolioOtherUser;
  final bool isSignIn;

  MyTopBar({
    this.leadingIcon,
    this.leadingImage,
    this.trailingIcon,
    this.trailingImage,
    this.leadingAction,
    this.trailingAction,
    this.isBackButton = false,
    this.isAvatar = false,
    this.isSearch = false,
    this.isFolderDropdown = false,
    this.isNextButton = false,
    this.isThreeDot = false,
    this.isExplore = false,
    this.isDiscover = false,
    this.isUpload = false,
    this.isMyProfile = false,
    this.isProfileOtherUser = false,
    this.isDescriptionPortfolio = false,
    this.isDescriptionPortfolioOtherUser = false,
    this.isSignIn = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          splashRadius: 24,
        ),
      ),
      actions: <Widget>[
        if (isAvatar)
          const CircleAvatar(
              // -- for avatar properties in discover page
              ),
        if (isSearch)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // -- search action
            },
          ),
        if (isFolderDropdown)
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              // -- folder dropdown action
            },
          ),
        if (isNextButton)
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              // -- next button action
            },
          ),
        if (isThreeDot)
          PopupMenuButton(
            itemBuilder: (context) => [
              // -- for setting page later
            ],
          ),
        if (isDiscover)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Image(
              image: AssetImage('images/logo-orange.png'),
              width: 31,
              height: 27,
            ),
          ),
        if (isExplore)
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              //--  explore page action
            },
          ),
        if (isSignIn)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Image(
              image: AssetImage('images/logo-white.png'),
              width: 31,
              height: 27,
            ),
          ),
      ],
    );
  }
}