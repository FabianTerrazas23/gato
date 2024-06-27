import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/config.dart';
import '../widget/celda.dart';

class Controles extends StatefulWidget {
  final Function actualizarContadores;

  const Controles({super.key, required this.actualizarContadores});

  @override
  State<Controles> createState() => _ControlesState();
}

class _ControlesState extends State<Controles> {
  estados inicial = estados.cruz;
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    double tamanoCelda = ancho < alto ? ancho / 3 : alto / 3;

    return Center(
      child: SizedBox(
        width: tamanoCelda * 3,
        height: tamanoCelda * 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Celda(
                      inicial: tablero[0],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(0)),
                  Celda(
                      inicial: tablero[1],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(1)),
                  Celda(
                      inicial: tablero[2],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(2)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Celda(
                      inicial: tablero[3],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(3)),
                  Celda(
                      inicial: tablero[4],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(4)),
                  Celda(
                      inicial: tablero[5],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(5)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Celda(
                      inicial: tablero[6],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(6)),
                  Celda(
                      inicial: tablero[7],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(7)),
                  Celda(
                      inicial: tablero[8],
                      alto: tamanoCelda,
                      ancho: tamanoCelda,
                      press: () => pressi(8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pressi(int index) {
    if (tablero[index] == estados.vacio) {
      setState(() {
        tablero[index] = inicial;
        inicial = inicial == estados.cruz ? estados.circulo : estados.cruz;
        contador++;
      });

      if (contador >= 5) {
        bool ganador = false;
        for (int i = 0; i < tablero.length; i += 3) {
          if (iguales(i, i + 1, i + 2)) ganador = true;
        }
        for (int i = 0; i < 3; i++) {
          if (iguales(i, i + 3, i + 6)) ganador = true;
        }
        if (iguales(0, 4, 8) || iguales(2, 4, 6)) ganador = true;

        if (ganador || contador == 9) {
          mostrarDialogoFinDeJuego(ganador);
        }
      }
    }
  }

  bool iguales(int a, int b, int c) {
    if (tablero[a] != estados.vacio &&
        tablero[a] == tablero[b] &&
        tablero[b] == tablero[c]) {
      widget.actualizarContadores(tablero[a]);
      return true;
    }
    return false;
  }

  void mostrarDialogoFinDeJuego(bool ganador) {
    String mensaje;
    if (ganador) {
      mensaje = inicial == estados.cruz
          ? '¡Felicitaciones, Circulo gana!'
          : '¡Felicitaciones, Cruz gana!';
    } else {
      mensaje = '¡Es un empate!';
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el diálogo se cierre al hacer clic fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Juego Terminado'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reiniciarJuego();
              },
              child: const Text('Continuar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop(); // Cerrar la aplicación
              },
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }

  void reiniciarJuego() {
    setState(() {
      tablero = List.filled(9, estados.vacio);
      inicial = estados.cruz;
      contador = 0; // Reiniciar el contador
    });
  }
}
