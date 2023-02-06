import 'dart:convert';

import 'package:flutter/material.dart';
import '../config/wp_config.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class CategoryBloc extends ChangeNotifier {
  List<Category> _categoryData = [];

  List<Category> get categoryData => _categoryData;

  Future fetchData() async {
    _categoryData.clear();
    notifyListeners();
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    var response = WpConfig.blockedCategoryIds.isEmpty
        ? await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wp/v2/categories?per_page=100&order=desc&orderby=count"),headers: headers)
        : await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wp/v2/categories?per_page=100&order=desc&orderby=count&exclude=" +
                WpConfig.blockedCategoryIds),headers: headers);
    List? decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _categoryData = decodedData!.map((m) => Category.fromJson(m)).toList();
    }
    _categoryData.insert(0, Category(name: "Live TV", id: 11));
    notifyListeners();
  }
}
