import 'dart:io';

import 'package:befriend/models/data/data_manager.dart';
import 'package:befriend/models/data/data_query.dart';
import 'package:befriend/models/objects/friendship.dart';
import 'package:befriend/models/objects/home.dart';
import 'package:befriend/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../objects/bubble.dart';

class UserManager {
  static Bubble? _instance;

  static Future<Home> userHome() async {
    Bubble homeUser = await getInstance();
    return Home.fromUser(homeUser);
  }

  /// Singleton.
  /// Returns the current player object.
  /// If the player object is not initialized, it is initialized.
  /// The player object is initialized by getting the data from the database.
  static Future<Bubble> getInstance() async {
    if (_instance == null) {
      DocumentSnapshot docs = await DataManager.getData();

      try {
        List<dynamic> friendIDs =
            DataManager.getList(docs, Constants.friendsDoc);
        String avatarUrl = DataManager.getString(docs, Constants.avatarDoc);
        List<Friendship> friendList =
            await DataQuery.friendList(docs.id, friendIDs);

        ImageProvider avatar = await DataQuery.getNetworkImage(avatarUrl);
        _instance = Bubble.fromMapWithFriends(docs, avatar, friendList);
      } catch (e) {
        debugPrint('(UserManager): ${e.toString()}');
      }
    }

    return _instance!;
  }

  /// refreshPlayer refreshes the player object.
  /// It is necessary to refresh the player object after the player data has been
  /// changed.
  static void refreshPlayer() {
    _instance = null;
  }

  static Future<ImageProvider> refreshAvatar(File file) async {
    _instance!.avatar = Image.file(file).image;
    return _instance!.avatar;
  }
}
