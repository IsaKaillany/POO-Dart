import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class DataService {
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);

  void carregar(int index){
    tableStateNotifier.value = _json[index] ?? [];
  }

  final Map<int, List<Map<String, String>>> _json = {
    0: [
      {
        "name": "The Captain's Bean",
        "origin": "Lintong, Sumatra",
        "intensifier": "Fresco"
      },
      {
        "name": "Strong Been",
        "origin": "Nayarit, Mexico",
        "intensifier": "Azedo"
      },
      {
        "name": "Red Java", 
        "origin": "Tolima, Colombia", 
        "intensifier": "Suave"
      }
    ],
    
    1: [
      {
        "name": "La Fin Du Monde",
        "style": "Bock",
        "ibu": "65"
      },
      {
        "name": "Sapporo Premiume",
        "style": "Sour Ale",
        "ibu": "54"
      },
      {
        "name": "Duvel", 
        "style": "Pilsner", 
        "ibu": "82"
      }
    ],

    2: [
      {
        "name": "Brasil",
        "continent": "America Latina",
        "population": "213,4 milhões"
      },
      {
        "name": "China",
        "continent": "Ásia",
        "population": "1,4 bilhão"
      },
      {
        "name": "França", 
        "continent": "Europa", 
        "population": "67,4 milhões"
      }
    ],
  };
}
final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatefulWidget { 
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Map<String, dynamic>> _itemsNavBar = [
    {
      "label": "Cafés",
      "icon": Icon(Icons.coffee_outlined),
      "columnNames": ["Nome", "Origem", "Intensidade"],
      "propertyNames": ["name", "origin", "intensifier"],
    },
    
    {
      "label": "Cervejas",
      "icon": Icon(Icons.local_drink_outlined),
      "columnNames": ["Nome", "Estilo", "IBU"],
      "propertyNames": ["name", "style", "ibu"],
    },
    
    {
      "label": "Nações",
      "icon": Icon(Icons.flag_outlined),
      "columnNames": ["Nome", "Continente", "População"],
      "propertyNames": ["name", "continent", "population"],
    },
  ];

  @override
  void initState() {
    super.initState();
    dataService.carregar(_selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      dataService.carregar(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsNavBar = _itemsNavBar[_selectedIndex];

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas"),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder:(context, value, child){
            return DataTableWidget(
              jsonObjects: value, 
              columnNames: itemsNavBar["columnNames"],
              propertyNames: itemsNavBar["propertyNames"]
            );
          }
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            for (var item in _itemsNavBar)
              BottomNavigationBarItem(
                label: item["label"],
                icon: item["icon"],
              ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      )
    );
  }
}

class NewNavBar extends HookWidget {
  final void Function(int)? itemSelectedCallback; 

  NewNavBar({this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        itemSelectedCallback?.call(index);
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

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
    {this.jsonObjects = const [],
    this.columnNames = const [],
    this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columnNames.map(
        (name) => DataColumn(
          label: Expanded(
            child: Text(name, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))
          )
        )
      ).toList(),
      rows: jsonObjects.map(
        (obj) => DataRow(
          cells: propertyNames.map(
            (propName) => DataCell(Text(obj[propName] ?? ""))
          ).toList()
        )
      ).toList()
    );
  }
}
