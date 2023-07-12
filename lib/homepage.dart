import 'package:flutter/material.dart';

import 'table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1FAEE),
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Container(
        color: Color(0xFFF1FAEE), // Hintergrundfarbe rot
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: LeftBlock(),
              ),
              Expanded(
                child: RightBlock(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeftBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Daten ansehen:',
            style: TextStyle(fontSize: 32, color: Color(0xFFF1D3557), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TableScreen()),
              );
            },
            child: Table(
              columnWidths: {
                0: FixedColumnWidth(300), // Breite der ersten Spalte auf 50 festlegen
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(),
              children: List<TableRow>.generate(
                5,
                (index) => TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          'Author',
                          style: TextStyle(fontSize: 24,  color: Color(0xFFF1D3557)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RightBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'neue Daten erstellen:',
            style: TextStyle(fontSize: 32,color: Color(0xFFF1D3557), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Formular'),
                    content: Form(
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(15, (index) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Feld ${index + 1}',
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Schließen'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add, size: 120,),
          ),
        ],
      ),
    );
  }
}

// class OtherPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alle Tabellen'),
//       ),
//       body: Center(
//         child: Text('Inhalte der anderen Seite'),
//       ),
//     );
//   }
// }
