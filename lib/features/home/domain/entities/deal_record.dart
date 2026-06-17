import 'package:equatable/equatable.dart';

/// Lifecycle of a brokered deal shown in the recent buy/sell history.
enum DealStatus { deposited, completed, cancelled }

/// A completed or in-progress buy/sell transaction the collaborator brokered.
/// Immutable value object — use [copyWith] to derive a changed instance.
class DealRecord extends Equatable {
  const DealRecord({
    required this.id,
    required this.propertyTitle,
    required this.customerName,
    required this.dealValue,
    required this.commission,
    required this.dateLabel,
    required this.status,
  });

  final String id;
  final String propertyTitle;
  final String customerName;

  /// Transaction value in VND.
  final double dealValue;

  /// Collaborator commission earned in VND.
  final double commission;

  /// Pre-formatted, localized date label (e.g. "12/06/2026").
  final String dateLabel;
  final DealStatus status;

  DealRecord copyWith({
    String? id,
    String? propertyTitle,
    String? customerName,
    double? dealValue,
    double? commission,
    String? dateLabel,
    DealStatus? status,
  }) {
    return DealRecord(
      id: id ?? this.id,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      customerName: customerName ?? this.customerName,
      dealValue: dealValue ?? this.dealValue,
      commission: commission ?? this.commission,
      dateLabel: dateLabel ?? this.dateLabel,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyTitle,
        customerName,
        dealValue,
        commission,
        dateLabel,
        status,
      ];
}
