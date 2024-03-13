import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_services/games_services.dart';

const androidLeaderboardId = 'CgkI-9Wn2O0VEAIQBQ';

class GPG {
  Future googlePlayGamesSignIn(BuildContext context) async {
    final authCode = await GameAuth.getAuthCode(
        '5200545345-pifsi37fsbmkn3uhaetimvlabel5l925.apps.googleusercontent.com');
    if (authCode != null) {
      try {
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          PlayGamesAuthProvider.credential(serverAuthCode: authCode),
        );
        return userCredential.user;
      } on FirebaseAuthException catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message!)));
      }
    }
  }

  Future<bool> signIn() async {
    try {
      await GameAuth.signIn();
      return await isSignedIn();
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  Future<bool> isSignedIn() async {
    var isSignedIn = await GameAuth.isSignedIn;
    return isSignedIn;
  }

  Future<void> getPlayerID() async {
    await Player.getPlayerID();
  }

  Future<void> getPlayerName() async {
    await Player.getPlayerName();
  }

  Future<int?> getPlayerScore() async {
    return await Player.getPlayerScore(
        androidLeaderboardID: androidLeaderboardId);
  }

  Future<void> showAccessPoint() async {
    await Player.showAccessPoint(AccessPointLocation.topLeading);
  }

  Future<void> hideAccessPoint() async {
    await Player.hideAccessPoint();
  }

  Future<void> incrementAchievement(String id) async {
    if (!await isSignedIn()) return;
    try {
      await Achievements.increment(
          achievement: Achievement(androidID: id, steps: 1));
    } on PlatformException catch (error) {
      if (error.code == 'failed_to_increment_achievements') {
        await loadAchievement();
        await incrementAchievement(id);
      }
    }
  }

  Future<void> unlockAchievement(String id) async {
    if (!await isSignedIn()) return;
    try {
      await Achievements.unlock(
          achievement: Achievement(
        androidID: id,
        // iOSID: 'ios_id',
        percentComplete: 100,
      ));
      // ignore: empty_catches
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> loadAchievement() async {
    await Achievements.loadAchievements();
  }

  Future<void> loadLeaderboardScores() async {
    await Leaderboards.loadLeaderboardScores(
        androidLeaderboardID: androidLeaderboardId,
        scope: PlayerScope.global,
        timeScope: TimeScope.allTime,
        maxResults: 10);
  }

  Future<void> showLeaderboards() async {
    try {
      await Leaderboards.showLeaderboards(
          androidLeaderboardID: androidLeaderboardId);
      // ignore: empty_catches
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> submitScore(int value) async {
    if (!await isSignedIn()) return;
    dynamic currentScore = await getPlayerScore();
    currentScore ??= 0;

    await Leaderboards.submitScore(
        score: Score(
      androidLeaderboardID: androidLeaderboardId,
      value: currentScore + value,
    ));
  }

  Future<void> showAchievements() async {
    try {
      await Achievements.showAchievements();
      // ignore: empty_catches
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> getSavedGames() async {
    try {
      await SaveGame.getSavedGames();
      // ignore: empty_catches
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteGame() async {
    await SaveGame.deleteGame(name: "slot1");
  }
}
