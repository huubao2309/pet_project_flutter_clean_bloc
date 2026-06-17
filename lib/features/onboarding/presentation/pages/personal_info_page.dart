import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/selectors/radio/benny_radio.dart';
import 'package:benny_style/selectors/switch/benny_label_switch.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/phone/country_code_picker.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/plan_type.dart';
import '../view_model/personal_info_state.dart';
import '../view_model/personal_info_view_model.dart';
import '../widgets/step_header.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PersonalInfoViewModel>(
      create: (_) => getIt<PersonalInfoViewModel>(),
      child: const _PersonalInfoView(),
    );
  }
}

class _PersonalInfoView extends StatelessWidget {
  const _PersonalInfoView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<PersonalInfoViewModel>();

    return Scaffold(
      backgroundColor: theme.colors.neutral100,
      appBar: AppBar(
        backgroundColor: theme.colors.white,
        leading: const BackButton(),
        title: StepHeader(
          title: 'onboarding.personal_info'.tr(),
          currentStep: 1,
          totalStep: 2,
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: ViewModelBuilder<PersonalInfoViewModel, PersonalInfoState>(
        builder: (context, state) => SingleChildScrollView(
          padding: EdgeInsets.all(theme.spacing.spacing12),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(theme, 'onboarding.first_name'.tr()),
                AppTextField(
                  hintText: 'onboarding.first_name_placeholder'.tr(),
                  onChanged: viewModel.onFirstNameChanged,
                ),
                SizedBox(height: theme.spacing.spacing12),
                _label(theme, 'onboarding.last_name'.tr()),
                AppTextField(
                  hintText: 'onboarding.last_name_placeholder'.tr(),
                  onChanged: viewModel.onLastNameChanged,
                ),
                SizedBox(height: theme.spacing.spacing12),
                _label(theme, 'onboarding.phone_number'.tr()),
                AppTextField(
                  hintText: 'onboarding.phone_number_placeholder'.tr(),
                  keyboardType: TextInputType.phone,
                  prefixIcon: _DialCodePrefix(
                    dialCode: state.dialCode,
                    onTap: () => CountryCodePicker.show(
                      selectedDialCode: state.dialCode,
                      onSelected: (country) =>
                          viewModel.onDialCodeChanged(country.dialCode),
                    ),
                  ),
                  onChanged: viewModel.onPhoneChanged,
                ),
                SizedBox(height: theme.spacing.spacing12),
                _label(theme, 'onboarding.address'.tr()),
                AppTextField(
                  hintText: 'onboarding.address_placeholder'.tr(),
                  onChanged: viewModel.onAddressChanged,
                ),
                const SizedBox(height: 4),
                Text(
                  'onboarding.address_min_input'.tr(),
                  style: theme.textStyle.captionDefault,
                ),
                SizedBox(height: theme.spacing.spacing12),
                BennyLabelSwitch(
                  height: 24,
                  value: state.createSelfContact,
                  suffixTitle: 'onboarding.contact_create_myself'.tr(),
                  onChange: (value) =>
                      viewModel.onCreateSelfContactChanged(value: value),
                ),
                SizedBox(height: theme.spacing.spacing12),
                Text(
                  'onboarding.use_plan'.tr(),
                  style: theme.textStyle.paragraphLabel
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                _PlanSelector(
                  selected: state.plan,
                  onSelected: viewModel.onPlanChanged,
                ),
                SizedBox(height: theme.spacing.spacing20),
                BennyPrimaryButton(
                  title: 'onboarding.first_step'.tr(),
                  isWrapContent: false,
                  onPressed: state.canSubmit
                      ? () {
                          if (viewModel.submit()) {
                            context.push(AppRoutes.billingInfo);
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

class _DialCodePrefix extends StatelessWidget {
  const _DialCodePrefix({required this.dialCode, required this.onTap});

  final String dialCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dialCode,
              style: theme.textStyle.paragraphDefault
                  .copyWith(color: theme.colors.neutral900),
            ),
            Icon(Icons.arrow_drop_down, color: theme.colors.neutral700),
          ],
        ),
      ),
    );
  }
}

class _PlanSelector extends StatelessWidget {
  const _PlanSelector({required this.selected, required this.onSelected});

  final PlanType selected;
  final ValueChanged<PlanType> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.neutral200),
        borderRadius: BorderRadius.circular(theme.spacing.spacing12),
      ),
      child: Column(
        children: [
          _option(
            theme,
            PlanType.personally,
            'onboarding.personal_plan'.tr(),
            'onboarding.personal_plan_caption'.tr(),
          ),
          Divider(height: 1, color: theme.colors.neutral200),
          _option(
            theme,
            PlanType.professionally,
            'onboarding.professional_plan'.tr(),
            'onboarding.professional_plan_caption'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _option(
    ThemeState theme,
    PlanType type,
    String title,
    String caption,
  ) {
    return InkWell(
      onTap: () => onSelected(type),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.spacing12),
        child: Row(
          children: [
            BennyRadio<PlanType>(
              value: type,
              isSelected: selected == type,
              onChange: onSelected,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textStyle.paragraphDefault
                        .copyWith(color: theme.colors.neutral900),
                  ),
                  const SizedBox(height: 2),
                  Text(caption, style: theme.textStyle.captionDefault),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
