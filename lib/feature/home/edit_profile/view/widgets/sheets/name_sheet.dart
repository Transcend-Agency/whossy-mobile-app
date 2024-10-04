import 'package:flutter/material.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';

class NameSheet extends StatefulWidget {
  final String? name;
  final String title;

  const NameSheet({super.key, this.name, required this.title});

  @override
  State<NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<NameSheet> {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();

  late String originalName;
  bool hasChanged = false;

  void update() {
    String currentName = nameController.text;

    bool isNameChanged = originalName != currentName;
    bool isNameValid = currentName.validateName() == null;

    setState(() {
      hasChanged = isNameChanged && isNameValid;
    });
  }

  @override
  void initState() {
    if (widget.name != null) {
      nameController.text = widget.name!;
    }

    originalName = nameController.text;

    nameController.addListener(update);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(nameFocusNode);
    });

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSheetScaffold(
      useBottomInsets: true,
      title: widget.title,
      topPadding: 16,
      exitIcon: hasChanged ? checkIcon() : cancelIcon(),
      onExit: () => Navigator.pop(
          context, hasChanged ? nameController.text.trim() : null),
      child: Padding(
        padding: pagePadding,
        child: Form(
          key: formKey,
          child: AppTextField(
            focusNode: nameFocusNode,
            textController: nameController,
            hintText: 'Enter your name',
            prefixIcon: search(),
            lengthLimit: 50, // You can adjust this limit
            padding: 13,
            curvierEdges: true,
            validation: (name) => name?.trim().validateName(),
          ),
        ),
      ),
    );
  }
}

Future<String?> showNameSheet({
  required BuildContext context,
  String? name,
  required String title,
}) {
  return showModalBottomSheet<String?>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => NameSheet(name: name, title: title),
  );
}
