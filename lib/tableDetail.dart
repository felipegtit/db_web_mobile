import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color appColor = Color(0xFFF1FAEE);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Author Table',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: appColor,
      ),
      home: AuthorTable(),
    );
  }
}

class AuthorTable extends StatefulWidget {
  @override
  _AuthorTableState createState() => _AuthorTableState();
}

class _AuthorTableState extends State<AuthorTable> {
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
    fetchTableData();
    // generateTableData();
    filteredData = tableData;
    // searchController.addListener(filterTableData);
  }

    Future<void> fetchTableData() async {
    final response = await http.get(Uri.parse('http://10.0.1.153/book/'));
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
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
    } else {
      print('Failed to fetch table data');
    }
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

  void addRow() {
    setState(() {
      rowCount++;
      List<String> newRowData = [
        rowCount.toString(),
        'Author $rowCount',
        (25 + rowCount).toString(),
        'Country ${rowCount % 5}',
        'Genre ${rowCount % 3}',
        'Books ${rowCount % 10}',
        (rowCount % 2 == 0) ? 'Active' : 'Inactive',
      ];
      tableData.add(newRowData);
      filteredData = tableData;
    });
  }

  void addColumn() {
    setState(() {
      columnCount++;
      String newColumnHeader = 'Column $columnCount';
      columnHeaders.add(newColumnHeader);
      for (int i = 0; i < rowCount; i++) {
        tableData[i].add('Data $columnCount');
      }
      filteredData = tableData;
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
        title: Text('Author Table'),
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
                    (index) => DataRow(
                      cells: List.generate(
                        columnCount,
                        (cellIndex) => DataCell(
                          Text(tableData[index][cellIndex].toString()),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: addRow,
            tooltip: 'Add Row',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: addColumn,
            tooltip: 'Add Column',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
