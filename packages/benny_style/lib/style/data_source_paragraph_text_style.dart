import 'data_source_text_style.dart';

class DataSourceParagraphTextStyle {
  final DataSourceTextStyle labelLink;
  final DataSourceTextStyle label;
  final DataSourceTextStyle inlineLink;
  final DataSourceTextStyle defaultPrimary;

  DataSourceParagraphTextStyle(
      {required this.labelLink,
      required this.label,
      required this.inlineLink,
      required this.defaultPrimary});
}
