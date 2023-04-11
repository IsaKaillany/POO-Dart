import 'package:flutter/material.dart';

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
                    title: const Text("Gabriel lindo"),
                ),
                body: DataBodyWidget(objects: [
                    "La Fin Du Monde - Bock - 65 ibu",
                    "Sapporo Premiume - Sour Ale - 54 ibu",
                    "Duvel - Pilsner - 82 ibu"
                ]),
                bottomNavigationBar: NewNavBar(icons: [Icon(Icons.home), Icon(Icons.local_drink), Icon(Icons.settings)],)
            )
        );
    }
}

class NewNavBar extends StatelessWidget {
    List<Icon> icons;
    NewNavBar({this.icons = const []});

    void botaoFoiTocado(int index) {
        print("Tocaram no botão $index");
    }

    @override
    Widget build(BuildContext context) {
        return BottomNavigationBar(
            onTap: botaoFoiTocado, 
            items: icons.map((obj) => BottomNavigationBarItem(icon: obj, label: "Label")
        ).toList());
    }
}

class DataBodyWidget extends StatelessWidget {
    List<String> objects;
    DataBodyWidget({this.objects = const []});
    
    // Expanded processarUmElemento(String obj) {
    //     return Expanded(
    //         child: Center(child: Text(obj))
    //     );
    // } //construtor
    
    @override
    Widget build(BuildContext context) {
        return Column(children: objects.map(
            (obj) => Expanded(
                child: Center(child: Text(obj))
            )
        ).toList());
    }
}