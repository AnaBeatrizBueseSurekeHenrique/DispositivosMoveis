import 'dart:ffi';
import 'dart:math';

enum Nomes { Maria, Joao, John, Mary }

void main(List<String> arguments) {
  print("Exercicio 1");
  List<String> frutas = ['Maçã', 'Uva', 'manga', 'Mamão', 'Abacaxi'];
  print(frutas);
  print("Exericio 2");
  print(frutas[2]);
  print("Exercicio 3");
  frutas.add('Laranja');
  print(frutas);
  frutas.remove('Maçã');
  print(frutas);
  print("Exercicio 4");
  for (int i = 0; i < frutas.length; i++) {
    if ((frutas[i][0] == frutas[i][0].toUpperCase())) {
      print(frutas[i]);
    }
  }
  print("Exercicio 5");
  frutas.forEach((fruta) {
    if (fruta[0] == fruta[0].toUpperCase()) {
      print(fruta);
    }
  });
  print("Exercicio 6");
  List<String> frutasComA = [];
  frutasComA.addAll(
    frutas.where((frutas) => (frutas[0] == 'A' || frutas[0] == 'a')),
  );
  print(frutasComA);
  print("Exercicio 7");
  Map<double, String> precoFrutas = {};
  double i = 3.5;
  frutas.forEach((fruta) {
    precoFrutas[i] = fruta;
    i += 5;
  });
  print(precoFrutas);
  print("Exercicio 8");
  precoFrutas.forEach((preco, fruta) {
    print('Fruta: ${fruta}, Preco: ${preco}');
  });
  print("Exercicio 9");
  List<int> numeros = List.generate(20, (i) => i * 3);
  List<int> novaLista = retornaPar(numeros, verifica: verificaPar);
  print(novaLista);
  print('Exercicio 10');
  Map<int, Nomes> pessoas = {
    16: Nomes.Maria,
    20: Nomes.Joao,
    60: Nomes.Mary,
    8: Nomes.John,
  };
  pessoas.forEach((idade, nome) {
    if (idade >= 18) {
      print(nome);
    }
  });
}

List<int> verificaPar(List<int> numeros) {
  List<int> aux = [];
  aux.addAll(numeros.where((numeros) => numeros % 2 == 0));
  return aux;
}

List<int> retornaPar(List<int> numeros, {required Function verifica}) {
  return verificaPar(numeros);
}
