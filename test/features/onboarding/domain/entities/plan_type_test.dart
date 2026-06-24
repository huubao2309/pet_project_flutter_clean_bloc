import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/domain/entities/plan_type.dart';

void main() {
  group('PlanType', () {
    test('has exactly two values', () {
      expect(PlanType.values, hasLength(2));
      expect(
        PlanType.values,
        containsAll([PlanType.personally, PlanType.professionally]),
      );
    });
  });
}
