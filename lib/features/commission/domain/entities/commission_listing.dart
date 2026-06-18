import 'package:equatable/equatable.dart';

/// Sales status of a high-commission property surfaced near the collaborator.
enum CommissionStatus { urgentSell, available, deposited }

/// A nearby property carrying a high collaborator commission, shown in the
/// Commission (Hoa hồng) feed. Immutable value object — derive changes with
/// [copyWith].
class CommissionListing extends Equatable {
  const CommissionListing({
    required this.id,
    required this.title,
    required this.address,
    required this.distanceKm,
    required this.price,
    required this.commissionRate,
    required this.commissionAmount,
    required this.commissionScore,
    required this.type,
    required this.status,
    this.expiresInDays,
  });

  final String id;
  final String title;
  final String address;

  /// Straight-line distance from the collaborator's current location, in km.
  final double distanceKm;

  /// Listing price in VND.
  final double price;

  /// Commission rate as a fraction, e.g. 0.03 for 3%.
  final double commissionRate;

  /// Commission payout in VND (price * rate, pre-computed by the source).
  final double commissionAmount;

  /// Attractiveness score 0–10 ranking how worthwhile the commission is.
  final double commissionScore;

  /// Localized property type label, e.g. "Căn hộ", "Nhà phố".
  final String type;
  final CommissionStatus status;

  /// Days until the listing expires; when small the UI flags "expiring soon".
  /// Null means no expiry pressure.
  final int? expiresInDays;

  /// Whether the listing should be flagged as expiring soon (≤ 3 days).
  bool get isExpiringSoon => expiresInDays != null && expiresInDays! <= 3;

  CommissionListing copyWith({
    String? id,
    String? title,
    String? address,
    double? distanceKm,
    double? price,
    double? commissionRate,
    double? commissionAmount,
    double? commissionScore,
    String? type,
    CommissionStatus? status,
    int? expiresInDays,
  }) {
    return CommissionListing(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      distanceKm: distanceKm ?? this.distanceKm,
      price: price ?? this.price,
      commissionRate: commissionRate ?? this.commissionRate,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      commissionScore: commissionScore ?? this.commissionScore,
      type: type ?? this.type,
      status: status ?? this.status,
      expiresInDays: expiresInDays ?? this.expiresInDays,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        address,
        distanceKm,
        price,
        commissionRate,
        commissionAmount,
        commissionScore,
        type,
        status,
        expiresInDays,
      ];
}
