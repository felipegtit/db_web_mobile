import 'package:flutter/material.dart';
import 'dart:convert';

import 'tableDetail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color appColor = Color(0xFFF1FAEE);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alle Tabellen',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: appColor,
      ),
      home: TableScreen(),
    );
  }
}

class TableScreen extends StatefulWidget {
  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  bool isLoading = true;
  List<List<String>> tableData = [];
  List<List<String>> filteredData = [];
  List<String> columnHeaders = [];

  int rowCount = 0;
  int columnCount = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // fetchTableData();
    loadJsonData();
    filteredData = tableData;
  }

  void loadJsonData() async {
    String jsonData = await DefaultAssetBundle.of(context).loadString('tables.json');
    final List<dynamic> decodedData = json.decode(jsonData);
    setState(() {
        List<Map<String, dynamic>> mapList =  List<Map<String, dynamic>>.from(decodedData);
        tableData = mapList.map((item) {
          return item.values.map((value) => value.toString()).toList();
        }).toList();
        // print(filteredData);
        columnHeaders = generateColumns(mapList);
        rowCount = decodedData.length;
        columnCount = columnHeaders.length;
        isLoading = false;
    });
  }

  List<String> generateColumns(List<Map<String, dynamic>> jsonDataList) {
    if (jsonDataList.isNotEmpty) {
      // Nehme den ersten Datensatz, um die Spalten zu generieren
      Map<String, dynamic> firstData = jsonDataList.first;
      return firstData.keys.map((key) {
        return key;
      }).toList();
    }
    return [];
  }

  void filterTableData() {
    String searchText = searchController.text.toLowerCase();
    setState(() {
      filteredData = tableData.where((row) {
        return row.any((cell) => cell.toLowerCase().contains(searchText));
      }).toList();
    });
  }

    @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF1FAEE),
      appBar: AppBar(
        title: Text('Alle Tabellen'),
      ),
      body: Column(
        children: [ 
          Container(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width: 700,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  sortColumnIndex: 0,
                  sortAscending: true,
                  columns: List.generate(
                    columnCount,
                    (index) => DataColumn(
                      label: Text(
                        columnHeaders[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          filteredData.sort((a, b) {
                            if (ascending) {
                              return a[columnIndex].compareTo(b[columnIndex]);
                            } else {
                              return b[columnIndex].compareTo(a[columnIndex]);
                            }
                          });
                        });
                      },
                    ),
                  ),
                  rows: List.generate(
                    tableData.length,
                    (index) => 
                      DataRow(
                      cells: List.generate(
                        columnCount,
                        (cellIndex) => DataCell(
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AuthorTable()),
                              );
                            },
                            child: Text(tableData[index][cellIndex].toString()),
                            // child: Text(data[index][headers[columnIndex]].toString()),
                          ),
                        ),
                      ),
                    )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
  }
}

