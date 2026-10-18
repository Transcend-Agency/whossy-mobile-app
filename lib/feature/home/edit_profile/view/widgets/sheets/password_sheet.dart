import 'package:flutter/material.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/utils.dart';

/// Asks for the account password, for example to confirm deleting the
/// account. Unlike the name sheet this applies no name rules, so any password
/// can be entered.
class PasswordSheet extends StatefulWidget {
  final String title;

  const PasswordSheet({super.key, required this.title});

  @override
  State<PasswordSheet> createState() => _PasswordSheetState();
}

class _PasswordSheetState extends State<PasswordSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.isNotEmpty) Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppSheetScaffold(
      useBottomInsets: true,
      title: widget.title,
      topPadding: 16,
      exitIcon: _hasText ? checkIcon() : cancelIcon(),
      onExit: () => Navigator.pop(context, _hasText ? _controller.text : null),
      child: Padding(
        padding: pagePadding,
        child: AppTextField(
          focusNode: _focusNode,
          textController: _controller,
          hintText: 'Enter your password',
          obscureText: _obscure,
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          action: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          padding: 13,
          curvierEdges: true,
        ),
      ),
    );
  }
}

Future<String?> showPasswordSheet({
  required BuildContext context,
  required String title,
}) {
  return showModalBottomSheet<String?>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => PasswordSheet(title: title),
  );
}
