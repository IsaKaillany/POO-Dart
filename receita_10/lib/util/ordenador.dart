class Ordenador {

  List ordernar(List objetos, String propriedade, bool trocouAoMenosUm) {
    List objetosOrdenados = List.of(objetos);

    do {
      trocouAoMenosUm = false;

      for (int i = 0; i < objetosOrdenados.length - 1; i++) {
        var atual = objetosOrdenados[i];
        var proximo = objetosOrdenados[i + 1];

        if (atual[propriedade].compareTo(proximo[propriedade]) > 0) {
          var aux = objetosOrdenados[i];
          objetosOrdenados[i] = objetosOrdenados[i + 1];
          objetosOrdenados[i + 1] = aux;
          trocouAoMenosUm = true;
        }
      }
    } while (trocouAoMenosUm);

    return objetosOrdenados;
  }
}