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
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes];
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
      queryParameters: {'size': '10'}); 

      http.read(coffeesUri).then((jsonString) {
      var coffeesJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': coffeesJson,
        'propertyNames': ['blend_name', 'origin', 'variety']
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
      };
    });
  }

  void carregarNacoes() async {
    try {
      var nationsUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/nation/random_nation',
      queryParameters: {'size': '10'}); 

      var jsonString = await http.read(nationsUri);
      var nationsJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': nationsJson,
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

  void carregarCervejas() async {
    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/beer/random_beer',
      queryParameters: {'size': '10'});

    http.read(beersUri).then((jsonString) {
      var beersJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': beersJson,
        'propertyNames': ["name","style","ibu"]
      };
    }).catchError((error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
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
      theme: ThemeData(primarySwatch: Colors.deepPurple),
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
                return ListWidget(
                  jsonObjects: value['dataObjects'],
                  propertyNames: value['propertyNames']);

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
      )
    );
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
      ]
    );
  }
}

class ListWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> propertyNames;

  ListWidget(
      {this.jsonObjects = const [],
      this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      separatorBuilder: (_, __) => Divider(
        height: 5,
        thickness: 2,
        indent: 10,
        endIndent: 10,
        color: Theme.of(context).primaryColor,
      ),
      itemCount: jsonObjects.length,
      itemBuilder: (_, index) {
        var title = jsonObjects[index][propertyNames[0]];
        var content = propertyNames
            .sublist(1)
            .map((prop) => jsonObjects[index][prop])
            .join(" - ");
        return Card(
            shadowColor: Theme.of(context).primaryColor,
            child: Column(children: [
              SizedBox(height: 10),
              //a primeira propriedade vai em negrito
              Text("${title}\n", style: TextStyle(fontWeight: FontWeight.bold)),
              //as demais vão normais
              Text(content),
              SizedBox(height: 10)
            ]));
      },
    );
  }
}
