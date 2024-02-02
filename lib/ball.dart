import 'package:coast_wars/grid.dart';

class PongBall {
  double posX = 0;
  double posY = 0;
  double spdX = 0;
  double spdY = 0;

  Team? team;
  PongBall(this.posX, this.posY, this.spdX, this.spdY);

  PongBall move() {
    posX += spdX;
    posY += spdY;
    return this;
  }
}
