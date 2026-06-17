import 'package:equatable/equatable.dart';

/// Sales status of a property the collaborator (CTV) is handling.
enum PropertyStatus { available, deposited, sold }

/// A property the collaborator is selling, as shown on the home dashboard.
/// Immutable value object — use [copyWith] to derive a changed instance.
class PropertyListing extends Equatable {
  const PropertyListing({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.type,
    required this.status,
  });

  final String id;
  final String title;
  final String address;

  /// Listing price in VND.
  final double price;

  /// Floor area in square metres.
  final double area;
  final int bedrooms;

  /// Localized property type label, e.g. "Căn hộ", "Nhà phố".
  final String type;
  final PropertyStatus status;

  PropertyListing copyWith({
    String? id,
    String? title,
    String? address,
    double? price,
    double? area,
    int? bedrooms,
    String? type,
    PropertyStatus? status,
  }) {
    return PropertyListing(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      price: price ?? this.price,
      area: area ?? this.area,
      bedrooms: bedrooms ?? this.bedrooms,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, address, price, area, bedrooms, type, status];
}
