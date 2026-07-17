import 'package:pet_project_flutter_clean_bloc/features/qr_scan/domain/entities/scanned_property.dart';

/// Resolves a scanned QR payload to a property. Mocked for now — every code
/// maps to the same demo listing, echoing the raw payload back. Swap the body
/// for a real lookup (decode the code, call the listings API) later.
abstract final class ScannedPropertyResolver {
  static ScannedProperty resolve(String code) {
    return ScannedProperty(
      code: code,
      title: 'Vinhomes Central Park',
      address: 'Bình Thạnh, TP. HCM',
      area: 78,
      bedrooms: 2,
      price: 5600000000,
      commissionAmount: 168000000,
    );
  }
}
