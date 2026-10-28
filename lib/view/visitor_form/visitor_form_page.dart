import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatekeep/helper/validators.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/provider/visitor_form_provider.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/utils/app_constants.dart';
import 'package:gatekeep/utils/app_dimensions.dart';
import 'package:gatekeep/view/base_selector.dart';
import 'package:gatekeep/view/base_view.dart';
import 'package:gatekeep/widgets/custom_button.dart';
import 'package:gatekeep/widgets/custom_dropdown.dart';
import 'package:gatekeep/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class VisitorFormPage extends StatelessWidget {
  final Visitor? visitor;

  const VisitorFormPage({super.key, this.visitor});

  @override
  Widget build(BuildContext context) {
    return BaseView<VisitorFormProvider>(
      onModelReady: (provider) => provider.configure(visitor),
      builder: (context) {
        final provider = context.read<VisitorFormProvider>();
        return Scaffold(
          appBar: AppBar(title: Text(provider.isEditMode ? 'Edit Visitor' : 'New Visitor')),
          body: SafeArea(
            child: Form(
              key: provider.formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.medium),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  const FormSectionLabel(text: 'PERSONAL DETAILS'),
                  CustomTextField(
                    controller: provider.nameController,
                    label: 'Visitor Name *',
                    icon: Icons.person_outline,
                    validator: (value) => Validators.required(value, 'Name'),
                  ),
                  const SizedBox(height: AppDimensions.medium),
                  CustomTextField(
                    controller: provider.mobileController,
                    label: 'Mobile Number *',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validators.mobile,
                  ),
                  const SizedBox(height: AppDimensions.medium),
                  CustomTextField(
                    controller: provider.emailController,
                    label: 'Email (optional)',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: AppDimensions.large),
                  const FormSectionLabel(text: 'VISIT DETAILS'),
                  CustomDropdown(
                    label: 'Visitor Type *',
                    icon: Icons.badge_outlined,
                    value: provider.visitorType,
                    items: AppConstants.visitorTypes,
                    onChanged: provider.setVisitorType,
                    validator: (value) => Validators.dropdown(value, 'visitor type'),
                  ),
                  const SizedBox(height: AppDimensions.medium),
                  CustomDropdown(
                    label: 'Project *',
                    icon: Icons.apartment_outlined,
                    value: provider.project,
                    items: AppConstants.projects,
                    onChanged: provider.setProject,
                    validator: (value) => Validators.dropdown(value, 'project'),
                  ),
                  const SizedBox(height: AppDimensions.medium),
                  CustomTextField(
                    controller: provider.purposeController,
                    label: 'Purpose of Visit *',
                    icon: Icons.notes_outlined,
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                    validator: (value) => Validators.required(value, 'Purpose'),
                  ),
                  const SizedBox(height: AppDimensions.large),
                  BaseSelector<VisitorFormProvider, bool>(
                    selector: (m) => m.busy,
                    builder: (context, busy) => Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Cancel',
                            outlined: true,
                            onPressed: busy ? null : () => NavigationService.goBack(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: CustomButton(
                            text: provider.isEditMode ? 'Save Changes' : 'Register',
                            isLoading: busy,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              provider.save();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FormSectionLabel extends StatelessWidget {
  final String text;

  const FormSectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
