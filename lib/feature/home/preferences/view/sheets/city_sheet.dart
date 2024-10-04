import 'package:flutter/material.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/utils/index.dart';

class CitySheet extends StatefulWidget {
  const CitySheet({super.key, this.city});

  final String? city;

  @override
  State<CitySheet> createState() => _CitySheetState();
}

class _CitySheetState extends State<CitySheet> {
  final cityController = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  final cityFocusNode = FocusNode();

  late String store;
  bool hasChanged = false;

  void update() {
    setState(() => hasChanged = store != cityController.text);
  }

  @override
  void initState() {
    if (widget.city != null) {
      cityController.text = widget.city!;
    }

    store = cityController.text;

    cityController.addListener(update);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(cityFocusNode);
    });

    super.initState();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }//

  @override
  Widget build(BuildContext context) {
    return AppSheetScaffold(
      useBottomInsets: true,
      exitIcon: hasChanged ? checkIcon() : cancelIcon(),
      onExit: () => Navigator.pop(
          context, hasChanged ? cityController.text.trim() : null),
      topPadding: 16,
      bottomPadding: 16,
      title: 'City of residence',
      child: Padding(
        padding: pagePadding,
        child: Form(
          key: formKey1,
          child: AppTextField(
            focusNode: cityFocusNode,
            textController: cityController,
            hintText: 'Enter city name',
            prefixIcon: search(),
            lengthLimit: 20,
            padding: 13,
            curvierEdges: true,
          ),
        ),
      ),
    );
  }
}

Future<String?> showCitySheet({
  required BuildContext context,
  String? city,
}) {
  return showModalBottomSheet<String?>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => CitySheet(city: city),
  );
}
