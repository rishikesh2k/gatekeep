import 'package:flutter/material.dart';
import 'package:gatekeep/helper/app_message.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/provider/base_provider.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/utils/app_constants.dart';
import 'package:gatekeep/utils/app_routes.dart';
import 'package:gatekeep/view/visitor_form/widgets/registered_dialog.dart';

class VisitorFormProvider extends BaseProvider {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  Visitor? oldVisitor;
  String? visitorType;
  String? project;

  bool get isEditMode => oldVisitor != null;

  void configure(Visitor? visitor) {
    oldVisitor = visitor;
    if (visitor == null) return;
    nameController.text = visitor.name;
    mobileController.text = visitor.mobile;
    emailController.text = visitor.email ?? '';
    purposeController.text = visitor.purpose;
    visitorType = AppConstants.visitorTypes.contains(visitor.visitorType) ? visitor.visitorType : null;
    project = AppConstants.projects.contains(visitor.project) ? visitor.project : null;
  }

  void setVisitorType(String? value) {
    visitorType = value;
  }

  void setProject(String? value) {
    project = value;
  }

  Visitor buildVisitor() {
    final email = emailController.text.trim();
    return Visitor(
      id: oldVisitor?.id ?? '',
      name: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      email: email.isEmpty ? null : email,
      visitorType: visitorType!,
      project: project!,
      purpose: purposeController.text.trim(),
    );
  }

  Future<void> save() async {
    if (busy || formKey.currentState?.validate() != true) return;

    try {
      if (isEditMode) {
        await runBusy(() => editVisitor());
      } else {
        await runBusy(() => registerVisitor());
      }
    } on ApiException catch (e) {
      AppMessage.error(e.message);
    }
  }

  Future<void> editVisitor() async {
    final visitor = buildVisitor();
    final updated = await api.updateVisitor(visitor.id, visitor.toFormJson());
    store.save(updated);
    AppMessage.success('Visitor details updated');
    NavigationService.goBack();
  }

  Future<void> registerVisitor() async {
    final created = await api.createVisitor(buildVisitor());
    store.save(created);
    await RegisteredDialog.show(created);
    NavigationService.navigateReplacementTo(AppRoutes.visitorDetailsPage, arguments: created.id);
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    purposeController.dispose();
    super.dispose();
  }
}
