/// Base contract for every use case in the application.
///
/// [Output] — what the use case returns (use [void] for fire-and-forget).
/// [Input]  — the params object it receives (use [NoParams] when none needed).
///
/// Each use case = one business action. BLoCs call [execute] and never
/// talk to repositories directly.
abstract class UseCase<Output, Input> {
  Future<Output> execute(Input params);
}

/// Placeholder params for use cases that require no input.
class NoParams {
  const NoParams();
}
