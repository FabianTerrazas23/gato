import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/config.dart';
import 'controles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int victoriasCruz = 0;
  int victoriasCirculo = 0;
  int empates = 0;

  int contador = 0;

  void actualizarContadores(estados ganador) {
    setState(() {
      if (ganador == estados.cruz) {
        victoriasCruz++;
      } else if (ganador == estados.circulo) {
        victoriasCirculo++;
      } else {
        empates++;
      }
    });
  }

  void mostrarDialogoReiniciarSalir(BuildContext context, String accion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$accion el juego'),
          content: Text('¿Deseas $accion el juego?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (accion == 'Reiniciar') {
                  reiniciarJuego();
                } else if (accion == 'Salir') {
                  SystemNavigator.pop();
                }
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void reiniciarJuego() {
    setState(() {
      tablero = List.filled(9, estados.vacio);
      contador = 0;
      var inicial = estados.cruz;
    });
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    double tamanoFuente = ancho * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gato'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Reiniciar') {
                reiniciarJuego();
              } else if (value == 'Salir') {
                SystemNavigator.pop();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Reiniciar', 'Salir'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                mostrarDialogoReiniciarSalir(context, 'Reiniciar');
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                mostrarDialogoReiniciarSalir(context, 'Salir');
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cruz: $victoriasCruz',
                style: TextStyle(fontSize: tamanoFuente),
              ),
              Text(
                'Circulo: $victoriasCirculo',
                style: TextStyle(fontSize: tamanoFuente),
              ),
              Text(
                'Empates: $empates',
                style: TextStyle(fontSize: tamanoFuente),
              ),
              SizedBox(
                width: ancho,
                height: alto * 0.6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "imagenes/board.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Controles(actualizarContadores: actualizarContadores),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
