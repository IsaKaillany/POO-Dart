import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart'; 

enum TableStatus{idle, loading, ready, error}
enum ItemType{beer, coffee, nation, none}

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none,
  });

  void carregar(int index) {
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes];
    funcoes[index]();
  }

  void carregarCafes() async {
    if (tableStateNotifier.value['status'] == TableStatus.loading) {
      return;
    }

    if (tableStateNotifier.value['itemType'] != ItemType.coffee) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': ItemType.coffee,
      };
    }

    try {
      final coffeesUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/coffee/random_coffee',
        queryParameters: {'size': '10'},
      );

      final jsonString = await http.read(coffeesUri);
      final coffeesJson = jsonDecode(jsonString);

      final updatedDataObjects = tableStateNotifier.value['status'] != TableStatus.loading
          ? [...tableStateNotifier.value['dataObjects'], ...coffeesJson]
          : coffeesJson;

      tableStateNotifier.value = {
        'itemType': ItemType.coffee,
        'status': TableStatus.ready,
        'dataObjects': updatedDataObjects,
        'propertyNames': ['blend_name', 'origin', 'variety'],
      };
    } catch (error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
      };
    }
  }

  void carregarNacoes() async {
    if (tableStateNotifier.value['status'] == TableStatus.loading) {
      return;
    }

    if (tableStateNotifier.value['itemType'] != ItemType.nation) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': ItemType.nation,
      };
    }

    try {
      final nationsUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/nation/random_nation',
        queryParameters: {'size': '10'},
      );

      final jsonString = await http.read(nationsUri);
      final nationsJson = jsonDecode(jsonString);

      final updatedDataObjects = tableStateNotifier.value['status'] != TableStatus.loading
          ? [...tableStateNotifier.value['dataObjects'], ...nationsJson]
          : nationsJson;

      tableStateNotifier.value = {
        'itemType': ItemType.nation,
        'status': TableStatus.ready,
        'dataObjects': updatedDataObjects,
        'propertyNames': ['nationality', 'language', 'capital', 'national_sport'],
      };
    } catch (error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
      };
    }
  }

  void carregarCervejas() async {
    if (tableStateNotifier.value['status'] == TableStatus.loading) {
      return;
    }

    if (tableStateNotifier.value['itemType'] != ItemType.beer) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': ItemType.beer,
      };
    }

    try {
      final beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/beer/random_beer',
        queryParameters: {'size': '10'},
      );

      final jsonString = await http.read(beersUri);
      final beersJson = jsonDecode(jsonString);

      final updatedDataObjects = tableStateNotifier.value['status'] != TableStatus.loading
          ? [...tableStateNotifier.value['dataObjects'], ...beersJson]
          : beersJson;

      tableStateNotifier.value = {
        'itemType': ItemType.beer,
        'status': TableStatus.ready,
        'dataObjects': updatedDataObjects,
        'propertyNames': ['name', 'style', 'ibu'],
      };
    } catch (error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
      };
    }
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  final functionsMap = {
    ItemType.beer: dataService.carregarCervejas,
    ItemType.coffee: dataService.carregarCafes,
    ItemType.nation: dataService.carregarNacoes
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: ValueListenableBuilder(
            valueListenable: dataService.tableStateNotifier,
            builder: (_, value, __) {
              int itemCount = value['dataObjects'].length;
              return Text('Itens Exibidos: $itemCount');
            },
          ),
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
                  propertyNames: value['propertyNames'],
                  scrollEndedCallback: functionsMap[value['itemType']],
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

class ListWidget extends HookWidget {
  final dynamic _scrollEndedCallback;
  final List jsonObjects;
  final List<String> propertyNames;

  ListWidget(
      {this.jsonObjects = const [],
      this.propertyNames = const [], 
      void Function() 
        ? scrollEndedCallback })
        : _scrollEndedCallback = scrollEndedCallback ?? false;

  @override
  Widget build(BuildContext context) {
    var controller = useScrollController();
    useEffect(
      (){
        //Código chamado após a primeira renderização do componente
        controller.addListener(
          (){
            if (controller.position.pixels == controller.position.maxScrollExtent)
            {
              if (_scrollEndedCallback is Function)
              {
                _scrollEndedCallback();
              }
            }
          }
        );
      },[controller]
    );

    return ListView.separated(
      controller: controller,
      padding: EdgeInsets.all(10),
      separatorBuilder: (_, __) => Divider(
        height: 5,
        thickness: 2,
        indent: 10,
        endIndent: 10,
        color: Theme.of(context).primaryColor,
      ),
      itemCount: jsonObjects.length+1,
      itemBuilder: (_, index) {
        if (index==jsonObjects.length)
          return Center(child: LinearProgressIndicator());
        
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
