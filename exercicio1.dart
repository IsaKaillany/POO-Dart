void main() {
  Produto arroz = Produto(preco: 5.00, nome: "Arroz branco", validade: "06/23");
  Produto cerveja = Produto(preco: 10.00, nome: "Cerveja", validade: "05/23");
  
  Item sacos = Item(produto: arroz, quantidade: 4);
  Item grade = Item(produto: cerveja, quantidade: 6);
  
  Venda venda = Venda(data: DateTime.now());
  venda.addItem(sacos);
  venda.addItem(grade);
  print(venda);
}

class Venda {
  final DateTime data;
  List<Item> itens = []; 
  
  double total() => itens.fold(0, (sum, element) => sum + element.totalI());  
  
  void addItem(Item item){
    itens.add(item);
  }
  
  Venda({required this.data});

  @override
  String toString() => "Data: $data \nItens: $itens \nValor da venda: ${total()}";
}

class Item {
  Produto produto;
  final double quantidade;
  
  double totalI() => quantidade * produto.preco;
 
  Item({required this.quantidade, required this.produto});
  
  @override
  String toString() => "\n$produto \nQuantidade: $quantidade \nPreço total: ${totalI()}";
}

class Produto {
  final double preco;
  final String nome;
  final String validade;
  
  Produto({required this.preco, required this.nome, required this.validade});
  
  @override
  String toString() => "\nProduto: $nome \nPreço: $preco \nValidade: $validade";
}