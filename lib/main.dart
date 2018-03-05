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
  ScrollController _controller = new ScrollController();

  double _startScale;
  double _startX;

  @override
  Widget build(BuildContext context) {
    return
      new GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onScaleStart: (details) {
          _startScale = 1.0;
          _startX = details.focalPoint.dx;
        },
        onScaleUpdate: (details) {
          var scale = 1 + _startScale - details.scale;
          var dx = _startX - details.focalPoint.dx;

          _startScale = details.scale;
          _startX = details.focalPoint.dx;

          // Scroll the focal point drift
          _controller.jumpTo(_controller.offset + dx);
          // Scale around the focal point
          setZoom(scale, _controller.offset + details.focalPoint.dx);
        },
        child:
        new CustomScrollPainter(
          // TODO calculate width based on zoom
          size: new Size(10000.0, 100.0),
          painter: new _ChartPainter(_zoom),
          controller: _controller,
        ),
      );
  }

  void setZoom(double scale, double focalPoint) {
    var dx = focalPoint * scale - focalPoint;
    _controller.jumpTo(_controller.offset - dx);
    setState(() => _zoom /= scale);
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
    return _zoom != oldDelegate._zoom;
  }
}
