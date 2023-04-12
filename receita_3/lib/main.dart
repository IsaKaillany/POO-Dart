import 'package:flutter/material.dart';

void main() {
    MyApp app = MyApp();
    runApp(app);
}

class MyApp extends StatelessWidget {  
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.teal),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar: CustomAppBar(),
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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{ //permite definir o tamanho específico de um widget 
    CustomAppBar();

    @override
    Size get preferredSize => Size.fromHeight(kToolbarHeight);

    @override
    Widget build(BuildContext context) {
        return AppBar(
            title: const Text("Gabriel lindo"),
            actions: [
                PopupMenuButton<Color>(
                    onSelected: (Color color) {
                        //Lógica para lidar com a seleção da cor
                    },
                    itemBuilder: (BuildContext context) { //define os itens do menu
                        return [
                            PopupMenuItem<Color>(
                                value: Colors.red,
                                child: Text("Red"),
                            ),
                            PopupMenuItem<Color>(
                                value: Colors.blue,
                                child: Text("Blue"),
                            ),
                            PopupMenuItem<Color>(
                                value: Colors.green,
                                child: Text("Green"),
                            ),
                        ];
                    }
                )
            ]
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
    
    @override
    Widget build(BuildContext context) {
        return Column(children: objects.map(
            (obj) => Expanded(
                child: Center(child: Text(obj))
            )
        ).toList());
    }
}