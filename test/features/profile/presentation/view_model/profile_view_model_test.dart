import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/entities/user_profile.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/view_model/profile_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/view_model/profile_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

const _profile = UserProfile(id: '1', fullName: 'Bao', phone: '0900000000');

void main() {
  setUpAll(() async {
    await ensureTestBinding();
    registerFallbackValue(const NoParams());
  });

  late MockGetProfileUseCase useCase;

  setUp(() {
    useCase = MockGetProfileUseCase();
  });

  ProfileViewModel build() => ProfileViewModel(getProfileUseCase: useCase);

  test('starts in ProfileInitial', () {
    final vm = build();
    expect(vm.currentState, isA<ProfileInitial>());
    vm.close();
  });

  test('loadProfile emits Loading then Loaded on success', () async {
    when(() => useCase.execute(any())).thenAnswer((_) async => _profile);
    final vm = build();
    final states = <ProfileState>[];
    final sub = vm.stream.listen(states.add);

    await vm.loadProfile();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [isA<ProfileLoading>(), isA<ProfileLoaded>()]);
    expect((vm.currentState as ProfileLoaded).profile, same(_profile));
    await vm.close();
  });

  test('loadProfile emits Loading then Error on AppException', () async {
    when(() => useCase.execute(any()))
        .thenThrow(ServerException(message: 'fetch failed'));
    final vm = build();
    final states = <ProfileState>[];
    final sub = vm.stream.listen(states.add);

    await vm.loadProfile();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [isA<ProfileLoading>(), isA<ProfileError>()]);
    expect((vm.currentState as ProfileError).message, 'fetch failed');
    await vm.close();
  });

  test('loadProfile is skipped when already loaded', () async {
    when(() => useCase.execute(any())).thenAnswer((_) async => _profile);
    final vm = build();
    await vm.loadProfile();

    await vm.loadProfile();

    verify(() => useCase.execute(any())).called(1);
    await vm.close();
  });

  test('refresh resets to Initial then reloads', () async {
    when(() => useCase.execute(any())).thenAnswer((_) async => _profile);
    final vm = build();
    await vm.loadProfile();

    final states = <ProfileState>[];
    final sub = vm.stream.listen(states.add);
    await vm.refresh();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [
      isA<ProfileInitial>(),
      isA<ProfileLoading>(),
      isA<ProfileLoaded>(),
    ]);
    verify(() => useCase.execute(any())).called(2);
    await vm.close();
  });
}
