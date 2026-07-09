import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gregtext_game/models/area.dart';
import 'package:flutter_gregtext_game/models/items/item.dart';
import 'package:flutter_gregtext_game/models/user/game_user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  DatabaseService({required this.userId});

  // User CRUD
  Future<void> saveUser(GameUser user) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<GameUser?> getUser() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return GameUser.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Real-time user updates
  Stream<GameUser?> streamUser() {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return GameUser.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Inventory operations
  Future<void> updateInventory(List<Item> inventory) async {
    await _firestore.collection('users').doc(userId).update({
      'inventory': {
        'inventory': inventory.map((item) => item.toMap()).toList(),
      },
    });
  }

  Future<void> addItemToInventory(Item newItem) async {
    final user = await getUser();
    if (user != null) {
      user.inventory.addItem(newItem);
      await updateInventory(user.inventory.inventory);
    }
  }

  Future<void> removeItemFromInventory(Item item) async {
    final user = await getUser();
    if (user != null) {
      user.inventory.removeItem(item);
      await updateInventory(user.inventory.inventory);
    }
  }

  // Game progress
  Future<void> updateGameStage(int stage) async {
    await _firestore.collection('users').doc(userId).update({
      'gameStage': stage,
    });
  }

  Future<void> addExploredArea(Area area) async {
    final user = await getUser();
    if (user != null && !user.exploredArea.any((a) => a.name == area.name)) {
      user.exploredArea.add(area);
      await _firestore.collection('users').doc(userId).update({
        'exploredArea': user.exploredArea.map((a) => a.toMap()).toList(),
      });
    }
  }

  Future<void> updatePlayedTime(Duration duration) async {
    final user = await getUser();
    if (user != null) {
      await _firestore.collection('users').doc(userId).update({
        'playedTime': duration.inSeconds,
      });
    }
  }

  // Batch updates for better performance
  Future<void> batchUpdate(Map<String, dynamic> updates) async {
    final user = await getUser();
    if (user != null) {
      WriteBatch batch = _firestore.batch();
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Convert any complex objects to maps
      Map<String, dynamic> finalUpdates = {};
      updates.forEach((key, value) {
        if (value is List<Item>) {
          finalUpdates[key] = value.map((item) => item.toMap()).toList();
        } else if (value is List<Area>) {
          finalUpdates[key] = value.map((area) => area.toMap()).toList();
        } else {
          finalUpdates[key] = value;
        }
      });

      batch.update(userRef, finalUpdates);
      await batch.commit();
    }
  }
}
