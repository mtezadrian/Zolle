// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import './product.dart' as p;
class SearchService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('searchKey',
        isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}

Stream<QuerySnapshot> loadAllProducts(p.Category category) {
  if (category == p.Category.todos) {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots();
  } else {
   // String cat = category.toString().substring(".");
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category.toString())
        .snapshots();
  }
}

List<p.Product> getProductsFromQuery(QuerySnapshot snapshot) {
  return snapshot.docs.map((DocumentSnapshot doc) {
    return p.Product.fromSnapshot(doc);
  }).toList();
}

Future<p.Product> getRestaurant(String productId) {
  return FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .get()
      .then((DocumentSnapshot doc) => p.Product.fromSnapshot(doc));
}

Stream<QuerySnapshot> loadCategoryProducts(p.Category category) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: category.toString())
      .snapshots();
}