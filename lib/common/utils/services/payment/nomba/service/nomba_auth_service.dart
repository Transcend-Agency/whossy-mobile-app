import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../../../env.dart';

class NombaAuthService {
  static final NombaAuthService _instance = NombaAuthService._internal();

  factory NombaAuthService() => _instance;

  NombaAuthService._internal()
      : clientId = Env.nombaClientId,
        clientSecret = Env.nombaClientSecret,
        accountId = Env.nombaAccountId;

  final String clientId;
  final String clientSecret;
  final String accountId;

  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiresAt;

  /// Gets a valid access token, refreshing or fetching a new one if needed.
  Future<String> getAccessToken() async {
    if (_accessToken != null &&
        _expiresAt != null &&
        DateTime.now().isBefore(_expiresAt!)) {
      return _accessToken!;
    }

    if (_refreshToken != null) {
      return await _refreshAccessToken();
    }

    return await _fetchAccessToken();
  }

  /// Fetches a new access token using client credentials.
  Future<String> _fetchAccessToken() async {
    final url = Uri.parse('https://api.nomba.com/v1/auth/token/issue');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accountId': accountId,
        },
        body: jsonEncode({
          "grant_type": "client_credentials",
          "client_id": clientId,
          "client_secret": clientSecret,
        }),
      );

      return _handleTokenResponse(response);
    } catch (e) {
      log("❌ Error fetching access token: $e");
      throw Exception("Authentication failed");
    }
  }

  /// Refreshes the access token using the refresh token.
  Future<String> _refreshAccessToken() async {
    final url = Uri.parse('https://api.nomba.com/v1/auth/token/refresh');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
          'accountId': accountId,
        },
        body: jsonEncode({
          "grant_type": "refresh_token",
          "refresh_token": _refreshToken,
        }),
      );

      return _handleTokenResponse(response, isRefresh: true);
    } catch (e) {
      log("❌ Error refreshing token: $e");
      return await _fetchAccessToken(); // Fallback to full re-authentication
    }
  }

  /// Handles token response and updates stored tokens.
  String _handleTokenResponse(http.Response response,
      {bool isRefresh = false,}) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['code'] == "00") {
      _accessToken = data['data']['access_token'];
      _refreshToken = data['data']['refresh_token'];
      _expiresAt = DateTime.parse(data['data']['expiresAt']);

      log(isRefresh
          ? "✅ Access token refreshed successfully"
          : "✅ Access token retrieved successfully");
      return _accessToken!;
    } else {
      _handleError(response.statusCode, data);
    }

    throw Exception("Unexpected error during authentication");
  }

  /// Handles API errors based on status codes and response messages.
  void _handleError(int statusCode, Map<String, dynamic> data) {
    final String message = data['description'] ?? "Unknown error";

    switch (statusCode) {
      case 400:
        throw Exception("Bad Request: $message");
      case 401:
        throw Exception("Unauthorized: $message");
      case 403:
        throw Exception("Forbidden: $message");
      case 404:
        throw Exception("Not Found: $message");
      case 429:
        throw Exception("Too Many Requests: $message");
      case 500:
        throw Exception("Server Error: $message");
      default:
        throw Exception("Unexpected Error: $message");
    }
  }
}