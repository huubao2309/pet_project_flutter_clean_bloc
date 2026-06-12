abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const main = '/main';
  static const loans = '/loans';
  static const loanDetail = '/loans/:loanId';
  static const apply = '/apply';

  static String loanDetailPath(String loanId) => '/loans/$loanId';
}
