import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

var dataObjects = [];

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("no build da classe MyApp");
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas"),
        ),
        body: DataTableWidget(jsonObjects: dataObjects),
        bottomNavigationBar: MyStatefulWidget(),
      )
    );
  }
}

class NewNavBar extends HookWidget { //é passível de ter um estado
  NewNavBar();

  @override
  Widget build(BuildContext context) {
    print("no build da classe NewNavBar");
    var state = useState(0);
    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas", 
          icon: Icon(Icons.local_drink_outlined)
        ),
        BottomNavigationBarItem(
          label: "Nações", 
          icon: Icon(Icons.flag_outlined)
        )
      ]
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => NewNavBar2();
}

class NewNavBar2 extends State<MyStatefulWidget> { //é passível de ter um estado
  NewNavBar2();

  int _selectIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.teal,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas", 
          icon: Icon(Icons.local_drink_outlined)
        ),
        BottomNavigationBarItem(
          label: "Nações", 
          icon: Icon(Icons.flag_outlined)
        )
      ]
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  DataTableWidget({this.jsonObjects = const []});

  @override
  Widget build(BuildContext context) {
    // print("no build da classe DataTableWidget");
    var columnNames = ["Nome", "Estilo", "IBU"],
        propertyNames = ["name", "style", "ibu"];

    return DataTable(
      columns: columnNames.map(
        (name) => DataColumn(
          label: Expanded(
            child: Text(name,style: TextStyle(fontStyle: FontStyle.italic))
          )
        )
      ).toList(),
      rows: jsonObjects.map(
        (obj) => DataRow(
          cells: propertyNames.map(
            (propName) => DataCell(Text(obj[propName]))
          ).toList()
        )
      ).toList());
  }
}
