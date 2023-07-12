import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart' as rootBundle;

import 'book_data_model.dart';

class TablePage extends StatefulWidget {
  final String name;

  const TablePage({Key? key, required this.name}) : super(key: key);

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
            future: readJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(child: Text("${data.error}"));
              } else if(data.hasData) {

                var items = data.data as List<BookDataModel>;

                return GridView.count(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 1,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(items.length, (index) {
                    return Container(
                      color: Colors.green,
                      child: InkWell(
                        onTap: () {
                          print("${items[index].title.toString()} was clicked");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              items[index].title.toString(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );

              } else {
                return const Center(child: CircularProgressIndicator());
              }

            }
        ),
      ),
    );

  }

  Future<List<BookDataModel>> readJsonData() async {
    final jsonData = await rootBundle.rootBundle.loadString('jsonfile/books.json');
    final list = json.decode(jsonData) as List<dynamic>;

    return list.map((e) => BookDataModel.fromJson(e)).toList();
  }

}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({required this.expandedValue, required this.headerValue, this.isExpanded = false});
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (index) {
    return Item(expandedValue: 'Panel $index', headerValue: 'This is item number $index');
  });
}