class BennyFontSize {
  late final FontSizeItem sm;
  late final FontSizeItem md;
  late final FontSizeItem lg;

  BennyFontSize() {
    sm = FontSizeItem(dataSource: FontSizeDataSource.sm);
    md = FontSizeItem(dataSource: FontSizeDataSource.md);
    lg = FontSizeItem(dataSource: FontSizeDataSource.lg);
  }
}

class FontSizeItem {
  late final Map<String, double> _dataSource;
  late final double h1Size;
  late final double h2Size;
  late final double h3Size;
  late final double pSize;
  late final double capSize;

  FontSizeItem({required Map<String, double> dataSource})
      : _dataSource = dataSource {
    _init();
  }

  _init() {
    h1Size = getSize("h1Size");
    h2Size = getSize("h2Size");
    h3Size = getSize("h3Size");
    pSize = getSize("pSize");
    capSize = getSize("capSize");
  }

  double get defaultSize => 12;

  double getSize(String key) {
    return _dataSource[key] ?? defaultSize;
  }
}

class FontSizeDataSource {
  static final Map<String, double> sm = {
    "h1Size": 24,
    "h2Size": 18,
    "h3Size": 14,
    "pSize": 13,
    "capSize": 11,
  };
  static final Map<String, double> md = {
    "h1Size": 28,
    "h2Size": 20,
    "h3Size": 15,
    "pSize": 14,
    "capSize": 12,
  };
  static final Map<String, double> lg = {
    "h1Size": 32,
    "h2Size": 22,
    "h3Size": 16,
    "pSize": 15,
    "capSize": 13,
  };
}
