abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const loans = '/loans';
  static const loanDetail = '/loans/:loanId';
  static const apply = '/apply';
  static const profile = '/profile';

  static String loanDetailPath(String loanId) => '/loans/$loanId';
}
