import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/decididor.dart';

var valores = [3, 7, 15]; 

enum TableStatus { idle, loading, ready, error }
enum ItemType{
  appliances, addresses, users, none;
  String get asString => '$name';

  List<String> get columns => this == addresses? ["Cidade", "Rua", "Endereço"] :
                              this == appliances? ["Marca", "Equipamento"]:
                              this == users? ["Nome", "Sobrenome", "Username"]:
                              [] ;

  List<String> get properties => this == addresses? ["city","street_name","street_address"] :
                              this == appliances? ["brand","equipment"]:
                              this == users? ["first_name","last_name","username"]:
                              [] ;
}

class DataService {
  static int get MAX_N_ITEMS => valores[2];
  static int get MIN_N_ITEMS => valores[0];
  static int get DEFAULT_N_ITEMS => valores[1];

  int _numberOfItems = DEFAULT_N_ITEMS;
  var objetoOriginal = [];

  set numberOfItems(n){
    _numberOfItems = n < 0 ? MIN_N_ITEMS: n > MAX_N_ITEMS? MAX_N_ITEMS: n;
  }

  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none,
  });


  void carregar(index) {
    final params = [ItemType.addresses, ItemType.appliances, ItemType.users];
    carregarPorTipo(params[index]);
  }

  void ordenarEstadoAtual(String propriedade, [bool cresc = true]) {
    List objetos = tableStateNotifier.value['dataObjects'] ?? [];

    if (objetos.isEmpty) return;

    var objetosOrdenados = objetos;
    bool crescente = cresc;

    bool precisaTrocar(atual, proximo) {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];
      return ordemCorreta[0][propriedade].compareTo(ordemCorreta[1][propriedade]) > 0;
    }

  objetosOrdenados.sort((a, b) {  
    if (precisaTrocar(a, b)) {
      return 1; 
    } 
    else if (precisaTrocar(b, a)) {
      return -1; 
    } 
    else {
      return 0; 
    }
  });

    emitirEstadoOrdenado(objetosOrdenados, propriedade);
  }

  void filtrarEstadoAtual(String filtro) {
    List objetos = objetoOriginal;
    
    if (objetos == []) return;

    List objetosFiltrados = objetoOriginal;

    if (filtro != '') {
      objetosFiltrados = objetos.where((objeto) =>
      objeto.toString().toLowerCase().contains(filtro.toLowerCase())).toList();
    }
    else {
      objetosFiltrados = objetoOriginal;
    }

    emitirEstadoFiltrado(objetosFiltrados);
  }


  Uri montarUri(ItemType type) {
    return Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/v2/${type.asString}',
      queryParameters: {'size': '$_numberOfItems'});
  }

  Future<List<dynamic>> acessarApi(Uri uri) async {
    var jsonString = await http.read(uri);
    var json = jsonDecode(jsonString);

    json = [...tableStateNotifier.value['dataObjects'], ...json];

    return json;
  }

  void emitirEstadoFiltrado(List objetosFiltrados) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['dataObjects'] = objetosFiltrados;
    tableStateNotifier.value = estado;
  }

  void emitirEstadoOrdenado(List objetosOrdenados, String propriedade){
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);

    estado['dataObjects'] = objetosOrdenados;
    estado['sortCriteria'] = propriedade;
    estado['ascending'] = true;
    tableStateNotifier.value = estado;
  }

  void emitirEstadoCarregando(ItemType type) {
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'itemType': type,
    };
  }

  void emitirEstadoPronto(ItemType type, var json) {
    tableStateNotifier.value = {
      'itemType': type,
      'status': TableStatus.ready,
      'dataObjects': json,
      'propertyNames': type.properties,
      'columnNames': type.columns,
    };
    objetoOriginal = json;
  }

  bool temRequisicaoEmCurso() =>
    tableStateNotifier.value['status'] == TableStatus.loading;

  bool mudouTipoDeItemRequisitado(ItemType type) =>
    tableStateNotifier.value['itemType'] != type;

  void carregarPorTipo(ItemType type) async {
    //ignorar solicitação se uma requisição já estiver em curso
    if (temRequisicaoEmCurso())
    {
      return;
    } 
    if (mudouTipoDeItemRequisitado(type)) {
      emitirEstadoCarregando(type);
    }

    var uri = montarUri(type);
    var json = await acessarApi(uri);

    emitirEstadoPronto(type, json);
  }
}

final dataService = DataService();


class DecididorJson implements Decididor {
  final String prop;
  final bool crescente;

  DecididorJson(this.prop, [this.crescente = true]);

  @override
  bool precisaTrocar(dynamic atual, dynamic proximo) {
    try {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];
      return ordemCorreta[0][prop].compareTo(ordemCorreta[1][prop]) > 0;
    } catch (error) {
      return false;
    }
  }
}