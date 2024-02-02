/* gridwidget.dart 
A widget that represents a grid that is of lower resolution than the screen.
It accepts taps and maps them to the underlying grid structure, 
and draws on the screen based on the grid state.
*/
import 'grid.dart';

import 'package:flutter/material.dart';

class GridWidget extends StatefulWidget {
  final FieldGrid grid;
  final int dim;
  final CustomPainter painter;
  final Function? tapHandler;

  const GridWidget({
    super.key,
    required this.grid,
    required this.dim,
    required this.painter,
    this.tapHandler,
  });

  @override
  State<GridWidget> createState() => GridWidgetState();
}

class GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    // var painter = SierpinskiPainter(grid: widget.grid, dim: widget.dim);
    var detector = GestureDetector(
        onTapDown: _onTapDown, child: CustomPaint(painter: widget.painter));

    return Container(
      height: widget.dim.toDouble(),
      width: widget.dim.toDouble(),
      color: Colors.pink,
      child: detector,
      // child: Row(children: [detector, detector]),);
    );
  }

  void _onTapDown(var details) {
    Offset tappedAt = details.localPosition;
    Offset gridPos = tapToGridPos(tappedAt);
    final int gridX = gridPos.dx.toInt();
    final int gridY = gridPos.dy.toInt();
    debugPrint('GridWidget::_onTapDown at $gridX, $gridY');

    setState(() {
      if (widget.tapHandler != null) {
        widget.tapHandler!(gridX, gridY);
      }
    });
    // widget.grid.setStateAt(gridX, gridY, !widget.grid.stateAt(gridX, gridY));
    // });
  }

  Offset tapToGridPos(Offset tapPos) {
    final int cellDim = widget.dim ~/ gridDim;
    final int gridX = tapPos.dx ~/ cellDim; //dart integer divide
    final int gridY = tapPos.dy ~/ cellDim;

    return Offset(gridX.toDouble(), gridY.toDouble());
  }
}

class GridPainter extends CustomPainter {
  final FieldGrid grid;
  final int dim;

  GridPainter(this.grid, this.dim);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    for (int r = 0; r < gridDim; r++) {
      for (int c = 0; c < gridDim; c++) {
        paint.color = (grid.teamAt(c, r) == Team.blue)
            ? Colors.lightBlue
            : Colors.lightGreen;
        var circDim = 10 / 2;
        canvas.drawCircle(
            Offset(c * 10 + circDim, r * 10 + circDim), circDim, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // debugPrint("GridWidget::shouldRepaint()");
    return true;
    //throw UnimplementedError();
  }
}
