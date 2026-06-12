import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoanDetailPage extends StatelessWidget {
  const LoanDetailPage({required this.loanId, super.key});

  final String loanId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('loan.title'.tr())),
      body: Center(child: Text('Loan ID: $loanId\n(TODO: implement)')),
    );
  }
}
