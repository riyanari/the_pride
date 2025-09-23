// models/checkout_model.dart
import 'package:the_pride/models/reward_model.dart';

class CheckoutModel {
  final RewardModel reward;
  final String specification;
  final int quantity;
  final int totalPoints;
  final DateTime checkoutDate;

  CheckoutModel({
    required this.reward,
    required this.specification,
    required this.quantity,
    required this.totalPoints,
    required this.checkoutDate,
  });
}