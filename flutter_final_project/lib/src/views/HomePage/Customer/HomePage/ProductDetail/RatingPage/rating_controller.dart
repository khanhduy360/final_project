import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final_project/src/helpers/shared_preferrence.dart';

class RatingController {
  StreamController _commentController = new StreamController.broadcast();
  StreamController _totalReviewController = new StreamController();
  StreamController _averageController = new StreamController();

  Stream get commentStream => _commentController.stream;
  Stream get totalReviewStream => _totalReviewController.stream;
  Stream get averageStream => _averageController.stream;

  setAveragePoint(double average) {
    _averageController.add(average);
  }

  setTotalReview(int total) {
    _totalReviewController.add(total);
  }

  onComment({
    String productId,
    String username,
    String comment,
    double ratingPoint,
  }) async {
    _commentController.sink.add('');
    int countError = 0;

    if (comment == '' || comment == null) {
      _commentController.sink.addError('Comment is empty.');
      countError++;
    }

    // TODO: add comment
    if (countError == 0) {
      print(productId);
      print(username);
      print(ratingPoint);
      print(comment);
      String type = await StorageUtil.getAccountType();
      await Firestore.instance.collection('Comments').document().setData({
        'product_id': productId,
        'name': username,
        'point': ratingPoint,
        'comment': comment,
        'type': type,
        'create_at': DateTime.now().toString()
      });
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    _commentController.close();
    _totalReviewController.close();
  }
}
