import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget { //transforma a class em um Widget a partir da já existente StatelessWidget (herança)
    List<Icon> icons;
    CustomNavBar({this.icons = const []});

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

class CustomBody extends StatelessWidget {
    CustomBody();

    @override
    Widget build(BuildContext context) {
        return Column(children: [
                Expanded(
                    child: Text("La Fin Du Monde - Bock - 65 ibu"),
                ),
                Expanded(
                    child: Text("Sapporo Premiume - Sour Ale - 54 ibu"),
                ),
                Expanded(
                    child: Text("Duvel - Pilsner - 82 ibu"),
                )
        ]);
    }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{ //permite definir o tamanho específico de um widget 
    CustomAppBar();

    @override
    Size get preferredSize => Size.fromHeight(kToolbarHeight); //o tamanho preferido do widget é definido como a altura padrão da barra de ferramentas

    @override
    Widget build(BuildContext context) {
        return AppBar(
            title: Text("Dicas")
        );
    }
}

class MyApp extends StatelessWidget {
    MyApp();

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            home: Scaffold(
                appBar: CustomAppBar(),
                body: CustomBody(),
                bottomNavigationBar: CustomNavBar(icons: [Icon(Icons.coffee_outlined), Icon(Icons.local_drink_outlined), Icon(Icons.flag_outlined)])),
        );
    }   
}

void main() {
    MyApp app = MyApp();
    runApp(app);
}