import 'package:custom_scroller/CustomScrollPainter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Test"),
        ),
        body: new Chart(),
      )));
}

class Chart extends StatefulWidget {
  Chart();

  @override
  ChartState createState() {
    return new ChartState();
  }
}

class ChartState extends State<Chart> {
  double _zoom = 100.0;
  double _startZoom;

  @override
  Widget build(BuildContext context) {
    return
      new GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onScaleStart: (details) => _startZoom = _zoom,
        onScaleUpdate: (details) =>
        // TODO: update the scroll position based on the scale
        setState(() => _zoom = _startZoom * details.scale),
        child:
        new CustomScrollPainter(
          // TODO calculate width based on zoom
            size: new Size(10000.0, 100.0),
            painter: new _ChartPainter(_zoom)),
      );
  }
}


class _ChartPainter extends CustomRegionPainter {
  double _zoom;

  Paint _linePaint = new Paint();

  _ChartPainter(this._zoom) {
    _linePaint.color = Colors.grey;
    _linePaint.strokeWidth = 1.0;
  }

  @override
  void paintRegion(Canvas canvas, Size size, Rect regionPx) {
    // Determine where to draw the first line
    double start = (regionPx.left / _zoom).floor() * _zoom;

    // Draw one line per _zoom distance
    while (start < regionPx.right) {
      canvas.drawLine(
          new Offset(start, regionPx.top),
          new Offset(start, regionPx.bottom),
          _linePaint
      );
      start += _zoom;
    }
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) {
    return true;
  }
}
