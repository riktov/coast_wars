import 'package:coast_wars/grid.dart';
import 'package:flutter/material.dart';

class PongBall {
  double posX = 0;
  double posY = 0;
  double spdX = 0;
  double spdY = 0;

  Team team;
  PongBall(this.posX, this.posY, this.spdX, this.spdY, this.team);

  PongBall move() {
    posX += spdX;
    posY += spdY;
    return this;
  }

  PongBall bounceX() {
    spdX = -1 * spdX;
    debugPrint("Bounce X!");
    return this;
  }

  PongBall bounceY() {
    spdY = -1 * spdY;
    return this;
  }
}
