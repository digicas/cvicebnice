import 'dart:ui';

import 'package:vector_math/vector_math.dart';

extension RectConversions on Rect{
  Rect fromOffsetSize(Offset offset, Size size) {
    return Rect.fromLTWH(offset.dx,offset.dy, size.width,size.height);
  }

}

extension VectorConversions on Vector{

}