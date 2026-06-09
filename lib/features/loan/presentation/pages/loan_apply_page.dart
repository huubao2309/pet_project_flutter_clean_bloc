import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoanApplyPage extends StatelessWidget {
  const LoanApplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('loan.apply.title'.tr())),
      body: Center(child: Text('loan.apply.title'.tr())),
    );
  }
}
