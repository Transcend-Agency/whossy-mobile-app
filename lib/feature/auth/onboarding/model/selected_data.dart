class SelectedData {
  final bool spinnerState;
  final int ticks;
  final bool isSelected;
  final bool isConnected;

  SelectedData({
    required this.spinnerState,
    required this.ticks,
    required this.isSelected,
    required this.isConnected,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedData &&
          runtimeType == other.runtimeType &&
          spinnerState == other.spinnerState &&
          ticks == other.ticks &&
          isSelected == other.isSelected &&
          isConnected == other.isConnected;

  @override
  int get hashCode =>
      spinnerState.hashCode ^
      ticks.hashCode ^
      isSelected.hashCode ^
      isConnected.hashCode;
}
