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

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Category { todos, amarillo, azul, verdeVidrio, punto, noReciclable, resto,}

class Product {
  final String category;
  final int id;
  final String name;
  final DocumentReference reference;


  Product._({this.category, this.id, this.name})
      : reference = null;
  Product.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
      category = snapshot.data()['category'],
      id = snapshot.data()['id'],
      name = snapshot.data()['name'],
      reference = snapshot.reference;


   String get assetName => '$id-0.jpg';
   String get assetPackage => 'shrine_images';

  @override
  String toString() => "$name (id=$id)";
}
