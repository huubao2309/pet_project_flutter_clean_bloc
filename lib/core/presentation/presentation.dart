/// Barrel for the swappable presentation foundation.
///
/// Import this single file in pages/view models instead of `flutter_bloc`.
/// All state-management coupling lives behind these abstractions, so swapping
/// the underlying library (Bloc → GetX → MobX …) is contained to this folder.
library;

export 'view_model.dart';
export 'view_model_builder.dart';
export 'view_model_consumer.dart';
export 'view_model_context_x.dart';
export 'view_model_listener.dart';
export 'view_model_provider.dart';
