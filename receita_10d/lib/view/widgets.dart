import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/gestures.dart';
import '../data/data_service.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

class Options {
  static const List<int> options = [3, 5, 7];
}

class MyApp extends StatelessWidget {
  final loadOptions = Options.options;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MyAppBar(),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            switch (value['status']) {
              case TableStatus.idle:
                return Center(child: Text("Toque em algum botão"));

              case TableStatus.loading:
                return Center(child: CircularProgressIndicator());

              case TableStatus.ready:
                return SingleChildScrollView(
                  child: DataTableWidget(
                    jsonObjects: value['dataObjects'],
                    propertyNames: value['propertyNames'],
                    columnNames: value['columnNames']));

              case TableStatus.error:
                return Text("Lascou");
            }

            return Text("...");
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

  NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
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
              label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.flag_outlined))
        ]);
  }
}

class DataTableWidget extends HookWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const [],
      this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    final sortAscending = useState(true);
    final sortColumnIndex = useState(0);

    return Center(
      child: DataTable(
        sortAscending: sortAscending.value,
        sortColumnIndex: sortColumnIndex.value,
        
        columns: columnNames
          .map((name) => DataColumn(
            onSort: (columnIndex, ascending) {
              sortColumnIndex.value = columnIndex;
              sortAscending.value = !sortAscending.value;

              dataService.ordenarEstadoAtual(propertyNames[columnIndex], sortAscending.value);
            },
            label: Expanded(
              child: Text(name,
                style: TextStyle(fontStyle: FontStyle.italic)))))
          .toList(),
        rows: jsonObjects
          .map((obj) => DataRow(
            cells: propertyNames
              .map((propName) => DataCell(Text(obj[propName])))
              .toList()))
          .toList()));
  }
}

class MyAppBar extends HookWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = useState(7);

    return AppBar(
      title: Text("Dicas"),
      actions: [
        SearchBar(
          leading: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          constraints: BoxConstraints(
            minWidth: 1.0,
            maxWidth: 280.0,
          ),
          onChanged: (filter) {
            if (filter.length >= 3) {
              dataService.filtrarEstadoAtual(filter);
            }
            else {
              dataService.filtrarEstadoAtual('');
            }
          },
        ),
        PopupMenuButton(
          initialValue: state.value,
          itemBuilder: (_) => valores
            .map((num) => PopupMenuItem(
                value: num,
                child: Text("Carregar $num itens por vez"),
              ))
            .toList(),
          onSelected: (number) {
            state.value = number;
            dataService.numberOfItems = number;
          },
        )
      ]
    );
  }
}
