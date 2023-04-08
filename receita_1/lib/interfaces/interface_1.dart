import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart'; 

void interface_1() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.cyan //padrão de cores que será usada
    ),
    home: Scaffold( //objeto gráfico estruturado para ser uma tela de app
      appBar: AppBar(title: Text("Top Linguagens de Programação")),
      body: Padding(
        padding: EdgeInsets.all(20), //adiciona um padding em todas as direções 
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("As 10 Linguagens de Programação Mais Usadas em 2023",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ),
              Text("A lista a seguir não está em ordem da mais usada para a menos usada.",
                    style: TextStyle(fontStyle: FontStyle.italic)
                  ),
              SizedBox(height: 10), // adiciona um espaçamento vertical de 10px
              Text("1. Python", style: TextStyle(fontSize: 16)),
              Text("2. C#", style: TextStyle(fontSize: 16)),
              Text("3. C++", style: TextStyle(fontSize: 16)),
              Text("4. JavaScript", style: TextStyle(fontSize: 16)),
              Text("5. PHP", style: TextStyle(fontSize: 16)),
              Text("6. Swift", style: TextStyle(fontSize: 16)),
              Text("7. Java", style: TextStyle(fontSize: 16)),
              Text("8. Go", style: TextStyle(fontSize: 16)),
              Text("9. SQL", style: TextStyle(fontSize: 16)),
              Text("10. Ruby", style: TextStyle(fontSize: 16)), 
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://becode.com.br/wp-content/uploads/2017/02/As-15-principais-linguagens-de-programa%C3%A7%C3%A3o-no-mundo.png',
                width: 350,
                height: 220
              ),
              Text("Font: https://www.hostinger.com.br/tutoriais/linguagens-de-programacao-mais-usadas", style: TextStyle(color: Colors.grey))
            ]  
          )
        )
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, //espaçamento entre os itens 
        children: <Widget> [
          ElevatedButton(
            child: Row(
              children: [Icon(Icons.share)],
            ),
            onPressed: () {}, //função que é executada quando o botão é pressionado
          ),
          ElevatedButton(
            child: Row(
              children: [Icon(Icons.thumb_up)],
            ),
            onPressed: () {},
          ),
          ElevatedButton(
            child: Row(
              children: [Icon(Icons.thumb_down)],
            ),
            onPressed: () {},
          )          
        ],
      )
    )
  );
  
  runApp(app);
}

