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

import 'dart:async';

import 'package:Zolle/category_menu_page.dart';
import 'package:Zolle/supplemental/asymmetric_view_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/product.dart' as product;
import '../search.dart';
import 'product_columns.dart';
import '../model/products_repository.dart' as data;

class AsymmetricView extends StatefulWidget {
  //static const route = '/';
  //AsymmetricView({Key key}) : super(key: key);
   product.Category _category;

  AsymmetricView({Key key, @required product.Category category})
    : super (key : key ?? ValueKey([category])) {
    _category = category;
  }  


  @override
  _AsymmetricView createState() => _AsymmetricView(category: _category);
}

class _AsymmetricView extends State<AsymmetricView> {
  _AsymmetricView({product.Category category}) {
    data.loadAllProducts(category).listen(_updateProducts);
  }

  @override
  void dispose() {
    _currentSubscription?.cancel();
    super.dispose();
  }


  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<product.Product> _products = <product.Product>[];

  void _updateProducts(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _products = data.getProductsFromQuery(snapshot);
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(0.0, 34.0, 16.0, 44.0),
      children: buildColumns(context, _products),

    );
  }
}


  List<Container> buildColumns(BuildContext context, List<product.Product> _products) {
  if (_products == null || _products.isEmpty) {
  return <Container>[];
  }

  /// This will return a list of columns. It will oscillate between the two
  /// kinds of columns. Even cases of the index (0, 2, 4, etc) will be
  /// TwoProductCardColumn and the odd cases will be OneProductCardColumn.
  ///
  /// Each pair of columns will advance us 3 products forward (2 + 1). That's
  /// some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
  /// helpers for creating the index of the product list that will correspond
  /// to the index of the list of columns.
  return List.generate(_listItemCount(_products.length), (int index) {
  double width = .59 * MediaQuery.of(context).size.width;
  Widget column;
  if (index % 2 == 0) {
  /// Even cases
  int bottom = _evenCasesIndex(index);
  column = TwoProductCardColumn(
  bottom: _products[bottom],
  top: _products.length - 1 >= bottom + 1
  ? _products[bottom + 1]
      : null);
  width += 32.0;
  } else {
  /// Odd cases
  column = OneProductCardColumn(
  product: _products[_oddCasesIndex(index)],
  );
  }
  return Container(
  width: width,
  child: Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  child: column,
  ),
  );
  }).toList();
  }
  int _evenCasesIndex(int input) {
    /// The operator ~/ is a cool one. It's the truncating division operator. It
    /// divides the number and if there's a remainder / decimal, it cuts it off.
    /// This is like dividing and then casting the result to int. Also, it's
    /// functionally equivalent to floor() in this case.
    return input ~/ 2 * 3;
  }

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    if (totalItems % 3 == 0) {
      return totalItems ~/ 3 * 2;
    } else {
      return (totalItems / 3).ceil() * 2 - 1;
    }
  }
