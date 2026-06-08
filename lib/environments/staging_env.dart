import 'env.dart';
import 'env_type.dart';

class StagingEnv extends Env {
  @override
  String get baseUrl => "https://pet.project.flutter.io/staging/v1";

  @override
  get envType => EnvType.staging;
}
