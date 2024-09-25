class CurrentChat {
  final String username;
  final String uidUser1;
  final String uidUser2;
  final String? profilePicUrl;
  final String? chatId;
  final int? oppIndex;
  final bool isBlocked;

  CurrentChat({
    required this.username,
    required this.uidUser1,
    required this.uidUser2,
    this.profilePicUrl,
    this.chatId,
    this.oppIndex,
    this.isBlocked = false,
  });

  CurrentChat copyWith({
    String? username,
    String? uidUser1,
    String? uidUser2,
    String? profilePicUrl,
    String? chatId,
    String? phone,
    int? oppIndex,
    bool? isDeleted,
    bool? isBlocked,
  }) {
    return CurrentChat(
      username: username ?? this.username,
      uidUser1: uidUser1 ?? this.uidUser1,
      uidUser2: uidUser2 ?? this.uidUser2,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      chatId: chatId ?? this.chatId,
      oppIndex: oppIndex ?? this.oppIndex,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}
