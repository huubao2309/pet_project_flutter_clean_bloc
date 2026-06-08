import 'env.dart';
import 'env_type.dart';

class UatEnv extends Env {
  @override
  String get baseUrl => "https://pet.project.flutter.io/uat/v1";

  @override
  get envType => EnvType.uat;
}
