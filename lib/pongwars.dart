import 'dart:async';

import 'package:coast_wars/ball.dart';
import 'package:coast_wars/gridwidget.dart';
import 'package:flutter/material.dart';
import 'grid.dart';
// import 'colorclipboard.dart';

class PongWarsPage extends StatefulWidget {
  const PongWarsPage({super.key, required this.title});

  final String title;

  @override
  State<PongWarsPage> createState() => _PongWarsPageState();
}

class _PongWarsPageState extends State<PongWarsPage> {
  final FieldGrid _grid;
  final int _dim = 400;
  Timer? timer;
  final PongBall _ball;

  _PongWarsPageState()
      : _grid = FieldGrid(),
        _ball = PongBall(0, 200, 5, 5);

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        // _grid.randomizeTeams();
        _ball.move();
        tryBounceWalls();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pong Wars'), actions: [
          IconButton(
            onPressed: _pushConfigure,
            icon: const Icon(Icons.settings),
            tooltip: 'Configure',
          ),
        ]),
        drawer: const Drawer(
          child: Text("Menu"),
        ),

        //need a container with some non-zero area to capture tap event
        body: SizedBox(
            width: _dim.toDouble(),
            child: Column(children: [
              // Row(children: [
              //   TextButton(
              //       onPressed: _onPressedRandState,
              //       child: const Text("Random States")),
              //   TextButton(
              //       onPressed: _onPressedShufColor,
              //       child: const Text("Shuffle Colors"))
              // ]),
              SizedBox(
                child: GridWidget(
                  grid: _grid,
                  dim: _dim,
                  painter: PongWarsPainter(_grid, _dim, _ball),
                ),
              ),
            ])));
  }

  void _pushConfigure() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: buildConfigurationPage));
  }

  Scaffold buildConfigurationPage(BuildContext context) {
    debugPrint("buildConfigurationPage");

    return Scaffold(
        appBar: AppBar(title: const Text("Configure")),
        body: SizedBox(
            width: _dim.toDouble(), child: const Column(children: [])));
  }

  void tryBounceWalls() {
    if (_ball.posX < 0 || _ball.posX > 400) {
      _ball.spdX = -1 * _ball.spdX;
    }
    if (_ball.posY < 0 || _ball.posY > 400) {
      _ball.spdY = -1 * _ball.spdY;
    }
  }
}

List<int> widgetToGridPos(Offset tapPos, int dim) {
  final int cellDim = dim ~/ gridDim;
  final int gridX = tapPos.dx ~/ cellDim; //dart integer divide
  final int gridY = tapPos.dy ~/ cellDim;

  return [gridX, gridY];
}

class PongWarsPainter extends GridPainter {
  PongBall ball;
  PongWarsPainter(super.grid, super.dim, this.ball);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    Paint paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.amber;

    canvas.drawCircle(Offset(ball.posX, ball.posY), 5, paint);
  }
}
