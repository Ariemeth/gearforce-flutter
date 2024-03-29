import 'dart:convert';

import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const _game_storage_url = 'https://gs.metadiversions.com/gf';

class ApiService {
  const ApiService();
  static Future<UnitRoster?> getRoster(Data data, String id) async {
    // id must be a uuid
    if (!Uuid.isValidUUID(fromString: id.trim())) {
      return null;
    }

    final response =
        await http.get(Uri.parse('$_game_storage_url/${id.trim()}'));
    if (response.statusCode == 200) {
      final rosterJson =
          (jsonDecode(response.body) as Map<String, dynamic>)['roster'];
      if (rosterJson != null || rosterJson != "") {
        return UnitRoster.fromJson(rosterJson, data);
      }
    }
    return null;
  }

  static Future<(String?, String?)> saveRoster(UnitRoster roster) async {
    final Map<String, dynamic> payload = {};
    payload['roster'] = roster.toJson();
    final response = await http.post(
      Uri.parse('$_game_storage_url/store/'),
      body: jsonEncode(payload),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final rosterId =
          (jsonDecode(response.body) as Map<String, dynamic>)['id'] as String;
      return (rosterId, null);
    }
    final error =
        (jsonDecode(response.body) as Map<String, dynamic>)['error'] as String;
    return (null, 'Status Code: ${response.statusCode}; $error');
  }
}
