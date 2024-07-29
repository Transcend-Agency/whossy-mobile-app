class ResetResponse {
  final bool isSuccess;
  final String message;

  ResetResponse({required this.isSuccess, required this.message});

  // Factory constructor for creating a new ResetResponse instance from a map.
  factory ResetResponse.fromJson(Map<String, dynamic> json) {
    return ResetResponse(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );
  }

  // Method to convert a ResetResponse instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
    };
  }
}
