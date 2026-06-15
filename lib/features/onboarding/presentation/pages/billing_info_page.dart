import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/messages/base_message_type.dart';
import 'package:benny_style/messages/snqd_message.dart';
import 'package:benny_style/textfields/benny_textfield.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/billing_info_state.dart';
import '../view_model/billing_info_view_model.dart';
import '../widgets/step_header.dart';

class BillingInfoPage extends StatelessWidget {
  const BillingInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BillingInfoViewModel>(
      create: (_) => getIt<BillingInfoViewModel>(),
      child: const _BillingInfoView(),
    );
  }
}

class _BillingInfoView extends StatelessWidget {
  const _BillingInfoView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<BillingInfoViewModel>();

    return Scaffold(
      backgroundColor: theme.colors.neutral100,
      appBar: AppBar(
        backgroundColor: theme.colors.white,
        leading: const BackButton(),
        title: StepHeader(
          title: 'onboarding.billing_info'.tr(),
          currentStep: 2,
          totalStep: 2,
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: ViewModelBuilder<BillingInfoViewModel, BillingInfoState>(
        builder: (context, state) => SingleChildScrollView(
          padding: EdgeInsets.all(theme.spacing.spacing12),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BennyMessage(
                  type: BaseMessageType.info,
                  title: 'onboarding.billing_title'.tr(),
                  message: 'onboarding.billing_caption'.tr(),
                ),
                SizedBox(height: theme.spacing.spacing12),
                _label(theme, 'onboarding.payment_cardholder'.tr()),
                BennyTextField<String>(
                  hintText: 'onboarding.card_name_placeholder'.tr(),
                  onTextChanged: viewModel.onNameOnCardChanged,
                ),
                SizedBox(height: theme.spacing.spacing12),
                _label(theme, 'onboarding.card_number'.tr()),
                BennyTextField<String>(
                  keyboardType: TextInputType.number,
                  onTextChanged: viewModel.onCardNumberChanged,
                ),
                SizedBox(height: theme.spacing.spacing12),
                _label(theme, 'onboarding.card_cvc'.tr()),
                BennyTextField<String>(
                  keyboardType: TextInputType.number,
                  onTextChanged: viewModel.onCvcChanged,
                ),
                SizedBox(height: theme.spacing.spacing12),
                _label(theme, 'onboarding.card_expire_date'.tr()),
                Row(
                  children: [
                    Expanded(
                      child: BennyTextField<String>(
                        hintText: 'onboarding.card_expire_month'.tr(),
                        keyboardType: TextInputType.number,
                        onTextChanged: viewModel.onMonthChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BennyTextField<String>(
                        hintText: 'onboarding.card_expire_year'.tr(),
                        keyboardType: TextInputType.number,
                        onTextChanged: viewModel.onYearChanged,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.spacing20),
                BennyPrimaryButton(
                  title: 'onboarding.second_step'.tr(),
                  isWrapContent: false,
                  onPressed: state.canSubmit
                      ? () {
                          if (viewModel.submit()) {
                            context.go(AppRoutes.main);
                          }
                        }
                      : null,
                ),
                SizedBox(height: theme.spacing.spacing20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(ThemeState theme, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: theme.textStyle.paragraphLabel
              .copyWith(color: theme.colors.neutral900),
        ),
      );
}
