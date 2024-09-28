import 'dart:convert';

import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const _default_base_url = 'https://hg.metadiversions.com';
const _game_storage_url = 'https://gs.metadiversions.com/gf';
//const _game_storage_url = "http://localhost:9000/gf";

class ApiService {
  const ApiService();
  static Future<UnitRoster?> getV3Roster(
      DataV3 data, String id, Settings settings) async {
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
        return UnitRoster.fromJson(rosterJson, data, settings);
      }
    }
    return null;
  }

  static Future<(String?, String?)> saveV3Roster(UnitRoster roster) async {
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

  static Future<String?> getLatestVersion(Uri baseUri) async {
    final uri = Uri.parse('$_default_base_url/version.json');

    try {
      final response = await http.get(uri).timeout(Duration(seconds: 3));
      if (response.statusCode != 200) {
        return null;
      }

      return (jsonDecode(response.body) as Map<String, dynamic>)['version'];
    } catch (e) {
      print('Unable to get the latest version within the alloted time(3s): $e');
      return null;
    }
  }
}
