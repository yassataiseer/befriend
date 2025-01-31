import 'package:befriend/models/data/data_query.dart';
import 'package:befriend/models/data/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../models/objects/friendship.dart';
import '../models/objects/home.dart';

class HomeProvider extends ChangeNotifier {
  double _scaleFactor = 1.0;

  Offset _position = Offset.zero;

  _AnimationType _animationType = _AnimationType.reset;
  Offset? _friendPosition;

  late AnimationController _animationController;
  late AnimationController _offsetController;

  late CurvedAnimation _animation;
  late Animation<Offset> _offsetAnimation;

  Home home;

  late final Listenable _listenable;

  Listenable get listenable => _listenable;
  double get scaleFactor => _scaleFactor;

  void notify() {
    notifyListeners();
  }

  Future<List<Friendship>> loadFriendships() async {
    if (!home.user.friendshipsLoaded) {
      home.user.friendships =
          await DataQuery.friendList(home.user.id, home.user.friendIDs);
      home.user.friendshipsLoaded = true;
      home.initializePositions();
    }

    return home.user.friendships;
  }

  Offset pageOffset() {
    return _animationType == _AnimationType.reset
        ? _position * (1 - _animation.value)
        : _offsetAnimation.value;
  }

  HomeProvider({required this.home});

  void init(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _position = Offset.zero;
        _animationController.reset();
      }
    });

    _offsetController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );
    _offsetController.addListener(() {
      if (_offsetController.isCompleted) {
        _position = _friendPosition!;
        _animationType = _AnimationType.reset;
      }
    });

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _offsetAnimation = Tween<Offset>(
      begin: _position,
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _offsetController, curve: Curves.easeInOut));

    _listenable = Listenable.merge([_animation, _offsetAnimation]);
    home.initializePositions();
  }

  void doDispose() {
    _animationController.dispose();
    _offsetController.dispose();
  }

  void scale(ScaleUpdateDetails details) {
    if (details.scale >= 1) {
      _scaleFactor = details.scale;
    }
    _position += details.focalPointDelta;
    notifyListeners();
  }

  void centerToMiddle() {
    _animationController.reset();
    _animationController.forward();
  }

  void animateToFriend(Offset friendPosition) {
    _animationType = _AnimationType.friend;
    _friendPosition = friendPosition * -1;

    _offsetAnimation = Tween<Offset>(
      begin: _position,
      end: _friendPosition!,
    ).animate(
        CurvedAnimation(parent: _offsetController, curve: Curves.easeInOut));

    _offsetController.reset();
    _offsetController.forward();
  }

  Future<void> signOut(BuildContext context) async {
    debugPrint('Signing out');
    await FirebaseAuth.instance.signOut();
    UserManager.refreshPlayer();
    if (context.mounted) {
      GoRouter.of(context).pushReplacement('/login');
    }
  }
}

enum _AnimationType { reset, friend }
