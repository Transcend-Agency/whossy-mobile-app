part of 'app_chip.dart';

class SingleSelectAppChip<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final bool outlined;

  const SingleSelectAppChip({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.outlined = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return AppChip(
      data: title,
      isSelected: isSelected,
      onTap: () => onChanged(value),
      outlined: outlined,
    );
  }
}
