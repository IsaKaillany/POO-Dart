import 'package:flutter/material.dart';

TextStyle _firstLine = TextStyle(
  fontWeight: FontWeight.bold, 
  fontSize: 15
);

void interface_2() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.indigo //padrão de cores que será usada
    ),
    home: Scaffold( //objeto gráfico estruturado para ser uma tela de app
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.local_bar_rounded),
          onPressed: () {},
        ),
        title: Text("Cervejas"),
      ),
      body: 
        SingleChildScrollView( //configura o tipo de scroll 
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20),          
          child: 
            DataTable(
              border: TableBorder.all(color: Color(0xff4b0082), width: 2),
                // showBottomBorder: true,
              columns: [
                DataColumn(label: Text("Nome", style: _firstLine)),
                DataColumn(label: Text("Estilo", style: _firstLine)),
                DataColumn(label: Text("IBU", style: _firstLine)),
                DataColumn(label: Text("País de origem", style: _firstLine))
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text("La Fin Du Monde")),
                  DataCell(Text("Bock")),
                  DataCell(Text("65")),
                  DataCell(Text("Bélgica"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Sapporo Premium")),
                  DataCell(Text("Sour Ale")),
                  DataCell(Text("54")),
                  DataCell(Text("Japão"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Duvel")),
                  DataCell(Text("Pilsner")),
                  DataCell(Text("82")),
                  DataCell(Text("Bélgica"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Heineken")),
                  DataCell(Text("Lager")),
                  DataCell(Text("23")),
                  DataCell(Text("Holanda"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Stella Artois")),
                  DataCell(Text("Belgian Pilsner")),
                  DataCell(Text("25")),
                  DataCell(Text("Bélgica"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Guinness")),
                  DataCell(Text("Stout")),
                  DataCell(Text("45")),
                  DataCell(Text("Irlanda"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Corona")),
                  DataCell(Text("American Lager")),
                  DataCell(Text("19")),
                  DataCell(Text("México"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Budweiser")),
                  DataCell(Text("American Lager")),
                  DataCell(Text("12")),
                  DataCell(Text("Estados Unidos"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Carlsberg")),
                  DataCell(Text("Pilsner")),
                  DataCell(Text("30")),
                  DataCell(Text("Dinamarca"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Asahi")),
                  DataCell(Text("Lager")),
                  DataCell(Text("18")),
                  DataCell(Text("Japão"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Coors Banquet")),
                  DataCell(Text("American Lager")),
                  DataCell(Text("10")),
                  DataCell(Text("Estados Unidos"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Amstel")),
                  DataCell(Text("Lager")),
                  DataCell(Text("21")),
                  DataCell(Text("Holanda"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Chimay")),
                  DataCell(Text("Belgian Dubbel")),
                  DataCell(Text("20")),
                  DataCell(Text("Bélgica"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Miller")),
                  DataCell(Text("American Lager")),
                  DataCell(Text("4")),
                  DataCell(Text("Estados Unidos"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Beck's")),
                  DataCell(Text("German Pilsner")),
                  DataCell(Text("20")),
                  DataCell(Text("Alemanha"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Duvel")),
                  DataCell(Text("Belgian Strong Ale")),
                  DataCell(Text("30")),
                  DataCell(Text("Bélgica"))
                ])
              ]
            ),
        ),
    )
  );
  
  runApp(app);
}

