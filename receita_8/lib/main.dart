import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart'; 

enum TableStatus{idle, loading, ready, error}
class DataService {
  final ValueNotifier<Map<String,dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': []
  });

  void carregar(index) {
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes, carregarBlood];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': []
    };
    funcoes[index]();
  }

  void carregarCafes() async {
    var coffeesUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/coffee/random_coffee',
      queryParameters: {'size': '5'}); 

      http.read(coffeesUri).then((jsonString) {
      var coffeesJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': coffeesJson,
        'columnNames': ['Nome', 'Origem', 'Variedade', 'Notas', 'Intensidade'],
        'propertyNames': ['blend_name', 'origin', 'variety', 'notes', 'intensifier']
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    });
  }

  void carregarCervejas() async {
    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/beer/random_beer',
      queryParameters: {'size': '5'});

    http.read(beersUri).then((jsonString) {
      var beersJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': beersJson,
        'columnNames': ["Nome", "Estilo", "IBU"],
        'propertyNames': ["name","style","ibu"]
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    });
  }

  void carregarNacoes() async {
    try {
      var nationsUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/nation/random_nation',
      queryParameters: {'size': '5'}); 

      var jsonString = await http.read(nationsUri);
      var nationsJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': nationsJson,
        'columnNames': ['Nacionalidade', 'Idioma', 'Capital', 'Esporte Nacional'],
        'propertyNames': ['nationality', 'language', 'capital', 'national_sport']
      };
    } 
    catch (error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    }
  }
  
  void carregarBlood() async {
    var bloodUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/v2/blood_types',
      queryParameters: {'size': '5'}); 

    http.read(bloodUri).then((jsonString) {
      var bloodJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': bloodJson,
        'columnNames': ['Tipo', 'Fator RH', 'Grupo'],
        'propertyNames': ['type', 'rh_factor', 'group']
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'columnNames': [],
      };
    });   
  }
}
final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas"),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            switch (value['status']) {
              case TableStatus.idle: 
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: 'https://static.vecteezy.com/system/resources/previews/003/073/700/large_2x/welcome-sign-dark-blue-with-light-neon-effect-shiny-glow-eps-free-vector.jpg',
                        width: 300,
                      ),   
                      SizedBox(height: 16),
                      Text("Clique em um dos botões abaixo para visualizar informações", 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)
                    ]
                  ),
                );
              case TableStatus.loading:
                return Center(child: CircularProgressIndicator());
              case TableStatus.ready: 
                return DataTableWidget(
                  jsonObjects: value['dataObjects'], 
                  propertyNames: value['propertyNames'], 
                  columnNames: value['columnNames']
                );
              case TableStatus.error: 
                return Center(
                  child: Text("Um erro ocorreu ao carregar os dados. Por favor verifique sua conexão de internet e tente novamente.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                return Text("...");
            }
          }
        ),
        bottomNavigationBar:
          NewNavBar(itemSelectedCallback: dataService.carregar),
      ));
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({itemSelectedCallback}): _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        state.value = index;
        _itemSelectedCallback(index);
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
        ),
        BottomNavigationBarItem(
            label: "Tipos Sanguíneo", 
            icon: Icon(Icons.water_drop_outlined)
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
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
              (propName) => DataCell(Text(obj[propName] ?? ''))
            ).toList()
          )
        ).toList()
      )
    ); 
  }
}
