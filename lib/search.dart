import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/products_repository.dart' as rep;
import 'supplemental/asymmetric_view.dart' as view;
import 'model/product.dart' as p;
import 'package:firebase_image/firebase_image.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() => new _Search();
}

class _Search extends State<Search> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    if (queryResultSet.length == 0 && value.length == 1) {
      rep.SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) ==
            true) {
          if (element['name'].toLowerCase().indexOf(value.toLowerCase()) == 0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }

    /*products = tempSearchStore.map((element) {
      return p.Product.fromSnapshot(element);
    }).toList();*/
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.light,
          title: Text('ZOLLE'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Búsqueda',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element, context);
              }).toList())
        ]));
  }
}

Widget buildResultCard(data, context) {
  final imageWidget = Image(image: FirebaseImage('gs://zolle-7845e.appspot.com/packages/'+data['id'].toString() + "-0.jpg"), fit: BoxFit.cover,);
  final ThemeData theme = Theme.of(context);
  String categoryString =
  data['category'].replaceAll('Category.', '').toUpperCase();
  if (categoryString == "PUNTO") {
    categoryString = "PUNTO LIMPIO";
  } else if(categoryString == "VERDEVIDRIO") {
    categoryString = "VERDE (IGLÚ)";
  } else if(categoryString == "NORECICLABLE") {
    categoryString = "NO RECICLABLE";
  }
  return Card(
    elevation: 0.0,
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 18 / 11,
          child: imageWidget,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(data['name'], style: theme.textTheme.headline6, maxLines: 1,),
              SizedBox(height: 8.0),
              Text(categoryString,
              style: theme.textTheme.subtitle2),
            ],
          ),
        ),
      ],
    ),
  );

}
