enum Valor {
  as,
  dois,
  tres,
  quatro,
  cinco,
  seis,
  sete,
  oito,
  nove,
  dez,
  valete,
  dama,
  rei,
}

enum Naipe { copas, ouro, espada, paus }

void main(List<String> arguments) {
  Main main = Main();
  main.main();
}

class Card {
  Card({required this.naipe, required this.valor});

  Naipe naipe;
  Valor valor;

  @override
  String toString() {
    String naipe;
    String valor;
    switch (this.valor) {
      case Valor.as:
        valor = 'ÁS';
        break;
      case Valor.dois:
        valor = '2';
        break;
      case Valor.tres:
        valor = '3';
        break;
      case Valor.quatro:
        valor = '4';
        break;
      case Valor.cinco:
        valor = '5';
        break;
      case Valor.seis:
        valor = '6';
        break;
      case Valor.sete:
        valor = '7';
        break;
      case Valor.oito:
        valor = '8';
        break;
      case Valor.nove:
        valor = '9';
        break;
      case Valor.dez:
        valor = '10';
        break;
      case Valor.valete:
        valor = 'VALETE';
        break;
      case Valor.dama:
        valor = 'DAMA';
        break;
      case Valor.rei:
        valor = 'REI';
        break;
    }
    switch (this.naipe) {
      case Naipe.copas:
        naipe = 'COPAS';
        break;
      case Naipe.ouro:
        naipe = 'OURO';
        break;
      case Naipe.espada:
        naipe = 'ESPADA';
        break;
      case Naipe.paus:
        naipe = 'PAUS';
        break;
    }
    return '$valor DE $naipe';
  }
}

class Baralho {
  Baralho() {
    Naipe auxNaipe;
    Valor auxValor;
    for (int i = 0; i < 4; i++) {
      switch (i) {
        case 0:
          auxNaipe = Naipe.copas;
          break;
        case 1:
          auxNaipe = Naipe.ouro;
          break;
        case 2:
          auxNaipe = Naipe.espada;
          break;
        case 3:
          auxNaipe = Naipe.paus;
          break;
        default:
          auxNaipe = Naipe.copas;
      }
      for (int j = 0; j < 13; j++) {
        switch (j) {
          case 0:
            auxValor = Valor.as;
            break;
          case 1:
            auxValor = Valor.dois;
            break;
          case 2:
            auxValor = Valor.tres;
            break;
          case 3:
            auxValor = Valor.quatro;
            break;
          case 4:
            auxValor = Valor.cinco;
            break;
          case 5:
            auxValor = Valor.seis;
            break;
          case 6:
            auxValor = Valor.sete;
            break;
          case 7:
            auxValor = Valor.oito;
            break;
          case 8:
            auxValor = Valor.nove;
            break;
          case 9:
            auxValor = Valor.dez;
            break;
          case 10:
            auxValor = Valor.valete;
            break;
          case 11:
            auxValor = Valor.dama;
            break;
          case 12:
            auxValor = Valor.rei;
            break;
          default:
            auxValor = Valor.as;
            break;
        }
        cartas.add(Card(naipe: auxNaipe, valor: auxValor));
      }
    }
  }
  List<Card> cartas = [];
  void embaralhar() {
    cartas.shuffle();
  }

  Card comprar() {
    return cartas.removeLast();
  }

  int cartasRestantes() {
    return cartas.length;
  }
}

class Main {
  void main() {
    Baralho deck = Baralho();
    deck.embaralhar();
    print(deck.comprar());
    print(deck.comprar());
    print(deck.comprar());
    print(deck.comprar());
    print(deck.comprar());
    print('Cartas restantes no baralho: ${deck.cartasRestantes()}');
  }
}
