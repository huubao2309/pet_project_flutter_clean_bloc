import 'package:equatable/equatable.dart';

/// The property a scanned QR code resolves to. Immutable value object.
class ScannedProperty extends Equatable {
  const ScannedProperty({
    required this.code,
    required this.title,
    required this.address,
    required this.area,
    required this.bedrooms,
    required this.price,
    required this.commissionAmount,
  });

  /// The raw QR payload that was scanned.
  final String code;
  final String title;
  final String address;

  /// Floor area in square metres.
  final double area;
  final int bedrooms;

  /// Listing price in VND.
  final double price;

  /// Collaborator commission payout in VND.
  final double commissionAmount;

  @override
  List<Object?> get props =>
      [code, title, address, area, bedrooms, price, commissionAmount];
}
