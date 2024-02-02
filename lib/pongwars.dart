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
  final List<PongBall> _balls;

  _PongWarsPageState()
      : _grid = FieldGrid(),
        _balls = List.empty(growable: true) {
    _balls.add(PongBall(25, 100, 5.4, 5, Team.blue));
    _balls.add(PongBall(375, 300, -5.2, -5.6, Team.green));
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        // _grid.randomizeTeams();
        for (var ball in _balls) {
          ball.move();
          if (ball.posX < 0) {
            ball.posX = 0;
          }
          if (ball.posY < 0) {
            ball.posY = 0;
          }
          if (ball.posX > 399) {
            ball.posX = 399;
          }
          if (ball.posY > 399) {
            ball.posY = 399;
          }

          tryBounceWalls(ball);
          tryHitBlocks(ball);
        }
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
                  painter: PongWarsPainter(_grid, _dim, _balls),
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

  void tryBounceWalls(PongBall ball) {
    if (ball.posX < 1 || ball.posX > 398) {
      ball.bounceX();
    }
    if (ball.posY < 1 || ball.posY > 398) {
      ball.bounceY();
    }
  }

  void tryHitBlocks(PongBall ball) {
    List<int> gridPos = widgetToGridPos((Offset(ball.posX, ball.posY)), 400);
    int gridX = gridPos[0];
    int gridY = gridPos[1];

    Team blockTeam = _grid.teamAt(gridPos[0], gridPos[1]);

    if (ball.team == blockTeam) {
      int blockCenterX = gridX * 10 + 5;
      int blockCenterY = gridY * 10 + 5;
      int diffX = (ball.posX.toInt() - blockCenterX).abs();
      int diffY = (ball.posY.toInt() - blockCenterY).abs();

      if (diffX > diffY) {
        ball.bounceX();
      } else {
        ball.bounceY();
      }

      if (ball.team == Team.blue) {
        _grid.setTeamAt(gridX, gridY, Team.green);
      } else {
        _grid.setTeamAt(gridX, gridY, Team.blue);
      }
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
  List<PongBall> balls;
  PongWarsPainter(super.grid, super.dim, this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    Paint paint = Paint()..style = PaintingStyle.fill;

    for (var ball in balls) {
      if (ball.team == Team.blue) {
        paint.color = Colors.lightBlue;
      } else {
        paint.color = Colors.lightGreen;
      }
      canvas.drawCircle(Offset(ball.posX, ball.posY), 5, paint);
    }
  }
}
