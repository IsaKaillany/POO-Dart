import 'package:flutter/material.dart';

var dataObjects = [
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
    },
    {
        "name": "Heineken",
        "style": "Lager",
        "ibu": "23"
    },
    {
        "name": "Stella Artois",
        "style": "Belgian Pilsner",
        "ibu": "25"
    },
    {
        "name": "Guinness",
        "style": "Stout",
        "ibu": "45"
    },
    {
        "name": "Corona",
        "style": "American Lager",
        "ibu": "19"
    },
    {
        "name": "Budweiser",
        "style": "American Lager",
        "ibu": "12"
    },
    {
        "name": "Carlsberg",
        "style": "Pilsner",
        "ibu": "30"
    },
    {
        "name": "Asahi",
        "style": "Lager",
        "ibu": "18"
    },
    {
        "name": "Coors Banquet",
        "style": "American Lager",
        "ibu": "10"
    },
    {
        "name": "Amstel",
        "style": "Lager",
        "ibu": "21"
    },
    {
        "name": "Chimay",
        "style": "Belgian Dubbel",
        "ibu": "20"
    },
    {
        "name": "Miller",
        "style": "American Lager",
        "ibu": "04"
    },
    {
        "name": "Beck's",
        "style": "German Pilsner",
        "ibu": "20"
    },
    {
        "name": "Duvel",
        "style": "Belgian Strong Ale",
        "ibu": "30"
    },
];
void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar: AppBar(
                    title: const Text("Dicas"),
                ),
                body: Center(
                    child: 
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataBodyWidget(objects: dataObjects)
                        )
                ),
                
                bottomNavigationBar: NewNavBar(),
            )
        );
    }
}

class NewNavBar extends StatelessWidget {
    NewNavBar();

    void botaoFoiTocado(int index) {
        print("Tocaram no botão $index");
    }

    @override
    Widget build(BuildContext context) {
        return BottomNavigationBar(onTap: botaoFoiTocado, items: const [
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
        ]);
    }
}

class DataBodyWidget extends StatelessWidget {
    List<Map<String,dynamic>> objects;
    DataBodyWidget({this.objects = const []});

    @override
    Widget build(BuildContext context) {
        var columnNames = ["Nome", "Estilo", "IBU"],
            propertyNames = ["name", "style", "ibu"];

        return DataTable(
            columns: columnNames.map(
                (name) => DataColumn(
                    label: Expanded(
                        child: Text(name, style: TextStyle(fontWeight: FontWeight.bold))
                    )
                )
            ).toList(),
            rows: objects.map(
                (obj) => DataRow(
                    cells: propertyNames.map(
                        (propName) => DataCell(Text(obj[propName]))
                    ).toList()
                )
            ).toList());
    }
}
