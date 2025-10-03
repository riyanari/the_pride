import 'dart:convert';

import 'package:http/http.dart' as http;

class WilayahService {
  static const baseUrl = "https://www.emsifa.com/api-wilayah-indonesia/api";

  static Future<List<dynamic>> getProvinces() async {
    final response = await http.get(Uri.parse("$baseUrl/provinces.json"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Gagal ambil data provinsi");
  }

  static Future<List<dynamic>> getRegencies(String provinceId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/regencies/$provinceId.json"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Gagal ambil data kabupaten");
  }

  static Future<List<dynamic>> getDistricts(String regencyId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/districts/$regencyId.json"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Gagal ambil data kecamatan");
  }

  static Future<List<dynamic>> getVillages(String districtId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/villages/$districtId.json"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Gagal ambil data kelurahan");
  }
}