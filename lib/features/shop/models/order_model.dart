import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/personalization/models/adddress/address_model.dart';
import 'package:flutter_application_1/features/shop/models/cart_item_model.dart';
import 'package:flutter_application_1/utils/constants/enum.dart';

import '../../../utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.address,
    this.deliveryDate,
    required this.items,
  });

  String get formattedOrderDate => HelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? HelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
          ? 'Shipment on the way'
          : 'Processing';

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      status: OrderStatus.values[json['status']],
      totalAmount: json['totalAMount'],
      orderDate: DateTime.parse(json['orderDate']),
      paymentMethod: json['paymentMethod'] ?? 'Paypal',
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.index,
      'totalAMount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      id: data['id'],
      userId: data['userId'],
      status: OrderStatus.values[data['status']],
      totalAmount: data['totalAMount'],
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] ?? 'Paypal',
      address: data['address'] != null
          ? AddressModel.fromJson(data['address'])
          : null,
      deliveryDate: data['deliveryDate'] != null
          ? (data['deliveryDate'] as Timestamp).toDate()
          : null,
      items: (data['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
    );
  }
}
