import 'dart:math';

import 'package:lista1/lista1.dart' as lista1;
import "dart:io";

// exercicio 1
void verificaSoma(int A, int B, int C) => ((A + B) < C)
    ? print("A soma de ${A} e ${B} é menor que ${C}")
    : print("A soma de ${A} e ${B} não é menor que ${C}");

//exercicio 2
void verificaParImpar(int numero) =>
    (numero) % 2 == 0 ? print('${numero} é par') : print('${numero} é impar');

//exercicio 3
void somaMultiplica(int A, int B) {
  int C;
  A == B ? (C = A + B) : C = (A * B);
  print(C);
}

//exercicio 4
void ordemDecrescente(int num1, int num2, int num3) {
  if (num1 != num2 && num2 != num3 && num3 != num1) {
    List<int> lista = [num1, num2, num3];
    for (int i = 0; i < 3; i++) {
      print(lista.reduce(max));
      lista.remove(lista.reduce(max));
    }
  } else {
    print("Os números devem ser diferentes!");
  }
}

//exercicio 5
void somaImparMultiplo3() {
  int soma = 0;
  for (int i = 1; i <= 500; i++) {
    if (i % 2 == 1 && i % 3 == 0) {
      soma += i;
    }
  }
  print(soma);
}

//exercicio 6
void geraImparesIntervalo() {
  for (int i = 100; i < 200; i++) {
    if (i % 2 == 1) {
      print(i);
    }
  }
}

//exercicio 7
void tabuada(int n) {
  for (int i = 0; i <= 10; i++) {
    print('${i} X ${n} = ${(i * n)}');
  }
}

//exercicio 8

void fatorial(int n) {
  stdout.write('${n}! =');
  int fatorial = 1;
  for (int i = n; i > 0; i--) {
    stdout.write(' ${i}');
    if (i > 1) {
      stdout.write(' X');
    }
    fatorial *= i;
  }
  stdout.write(' = ${fatorial}');
}

void main(List<String> arguments) {
  print("Exercicio 1");
  verificaSoma(1, 2, 3);
  verificaSoma(3, 4, 1);
  verificaSoma(1, 2, 10);

  print("Exercicio 2");
  verificaParImpar(1);
  verificaParImpar(2);

  print("Exercicio 3");
  somaMultiplica(2, 2);
  somaMultiplica(2, 3);

  print("Exercicio 4");
  ordemDecrescente(1, 2, 3);
  ordemDecrescente(1, 1, 2);
  ordemDecrescente(4, 3, 1);

  print("Exercicio 5");
  somaImparMultiplo3();

  print("Exercicio 6");
  geraImparesIntervalo();

  print("Exercicio 7");
  tabuada(2);

  print("Exercicio 8");
  fatorial(3);
}
