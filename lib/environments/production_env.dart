import 'env.dart';
import 'env_type.dart';

class ProductionEnv extends Env {
  @override
  String get baseUrl => 'https://pet.project.flutter.io/prod/v1';

  @override
  EnvType get envType => EnvType.production;
}
