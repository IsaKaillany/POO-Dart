import "package:flutter/material.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                title: Text("Forms"),
            ),
            body: MyForm(),
        ),
    );
  }
}

class MyForm extends StatefulWidget {
    @override
    _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
    final _formKey = GlobalKey<FormState>();
    String _age = ""; 
    String _education = "sup";

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: "Nome",
                            ),
                            validator: (value) {
                                if (value!.isEmpty) {
                                    return "Por favor, digite seu nome";
                                }
                                return null;
                            },
                        ),
                        TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "E-mail",
                            ),
                            validator: (value) {
                                if (value!.isEmpty) {
                                    return "Por favor, digite seu e-mail";
                                }
                                return null;
                            },
                        ),
                        SizedBox(height: 15),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Text(
                                    "Idade:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                RadioListTile<String>(
                                    title: Text("0 a 18 anos"),
                                    value: "0-18",
                                    groupValue: _age,
                                    onChanged: (value) {
                                        setState(() {
                                            _age = value!;
                                        });
                                    },
                                ),
                                RadioListTile<String>(
                                    title: Text("19 a 45 anos"),
                                    value: "19-40",
                                    groupValue: _age,
                                    onChanged: (value) {
                                        setState(() {
                                            _age = value!;
                                        });
                                    },
                                ),
                                RadioListTile<String>(
                                    title: Text("+ de 45 anos"),
                                    value: "+45",
                                    groupValue: _age,
                                    onChanged: (value) {
                                        setState(() {
                                            _age = value!;
                                        });
                                    },
                                ),
                                SizedBox(height: 15),
                                Text(
                                    "Nível de escolaridade:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                DropdownButtonFormField<String>(
                                    value: _education,
                                    items: [
                                        DropdownMenuItem(
                                            child: Text("Superior completo/incompleto"),
                                            value: "sup",
                                        ),
                                        DropdownMenuItem(
                                            child: Text("Ensino médio completo/incompleto"),
                                            value: "em",
                                        ),
                                        DropdownMenuItem(
                                            child: Text("Ensino fundamental completo/incompleto"),
                                            value: "ef",
                                        ),
                                    ],
                                    onChanged: (value) {
                                        setState(() {
                                            _education = value!;
                                        });
                                    },
                                ),
                            ],
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                                onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text("Formulário em processamento"),
                                            ),
                                        );
                                    }
                                },
                                child: Text("Enviar"),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
