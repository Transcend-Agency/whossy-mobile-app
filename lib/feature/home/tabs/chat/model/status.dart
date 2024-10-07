import 'package:cloud_firestore/cloud_firestore.dart'; // If you're using Firestore's Timestamp
import 'package:intl/intl.dart'; // Make sure to import this for date formatting
import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart'; // This is the generated file

@JsonSerializable()
class Status {
  final int lastSeen; // In milliseconds since epoch
  final bool online;

  Status({required this.lastSeen, required this.online});

  // Factory constructor for creating a new Status instance from a map.
  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  // Method for converting a Status instance to a map.
  Map<String, dynamic> toJson() => _$StatusToJson(this);

  String getLastSeen(Timestamp currentTime) {
    // Convert lastSeen milliseconds to DateTime
    final time = DateTime.fromMillisecondsSinceEpoch(lastSeen);
    final currentDateTime = currentTime.toDate();
    final difference = currentDateTime.difference(time);

    if (difference.inHours >= 48 || (currentDateTime.day - time.day >= 2)) {
      final formatter = DateFormat('MMM dd, yyyy');
      return 'Last seen ${formatter.format(time)}';
    } else if (difference.inHours >= 24) {
      final formatter = DateFormat("h:mm a");
      return 'Yesterday at ${formatter.format(time)}';
    } else if (difference.inHours >= 1) {
      return 'Last seen ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return 'Last seen ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Last seen just now';
    }
  }
}
