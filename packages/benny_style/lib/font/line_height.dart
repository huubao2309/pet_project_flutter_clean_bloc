class BennyLineHeight {
  late final LineHeightItem sm;
  late final LineHeightItem md;
  late final LineHeightItem lg;

  BennyLineHeight() {
    sm = LineHeightItem(dataSource: LineHeightDataSource.sm);
    md = LineHeightItem(dataSource: LineHeightDataSource.md);
    lg = LineHeightItem(dataSource: LineHeightDataSource.lg);
  }
}

class LineHeightItem {
  late final Map<String, double> _dataSource;
  late final double h1Line;
  late final double h2Line;
  late final double h3Line;
  late final double pLine;
  late final double capLine;

  LineHeightItem({required Map<String, double> dataSource})
      : _dataSource = dataSource {
    _init();
  }

  _init() {
    h1Line = getSize("h1Line");
    h2Line = getSize("h2Line");
    h3Line = getSize("h3Line");
    pLine = getSize("pLine");
    capLine = getSize("capLine");
  }

  double get defaultSize => 12;

  double getSize(String key) {
    return _dataSource[key] ?? defaultSize;
  }
}

class LineHeightDataSource {
  static final Map<String, double> sm = {
    "h1Line": 36,
    "h2Line": 28,
    "h3Line": 20,
    "pLine": 20,
    "capLine": 16,
  };
  static final Map<String, double> md = {
    "h1Line": 40,
    "h2Line": 32,
    "h3Line": 22,
    "pLine": 22,
    "capLine": 18,
  };
  static final Map<String, double> lg = {
    "h1Line": 44,
    "h2Line": 36,
    "h3Line": 24,
    "pLine": 24,
    "capLine": 20,
  };
}
