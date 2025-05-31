// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the FLUTTER.LICENSE file.

// @dart = 2.12
part of 'helpers.dart';

/// Base class for [DAGSize] and [DAGOffset], which are both ways to describe
/// a distance as a two-dimensional axis-aligned vector.
abstract class OffsetBase {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  ///
  /// The first argument sets the horizontal component, and the second the
  /// vertical component.
  const OffsetBase(this._dx, this._dy)
      : assert(_dx != null),
        assert(_dy != null);

  final double _dx;
  final double _dy;

  /// Returns true if either component is [double.infinity], and false if both
  /// are finite (or negative infinity, or NaN).
  ///
  /// This is different than comparing for equality with an instance that has
  /// _both_ components set to [double.infinity].
  ///
  /// See also:
  ///
  ///  * [isFinite], which is true if both components are finite (and not NaN).
  bool get isInfinite => _dx >= double.infinity || _dy >= double.infinity;

  /// Whether both components are finite (neither infinite nor NaN).
  ///
  /// See also:
  ///
  ///  * [isInfinite], which returns true if either component is equal to
  ///    positive infinity.
  bool get isFinite => _dx.isFinite && _dy.isFinite;

  /// Less-than operator. Compares an [DAGOffset] or [DAGSize] to another [DAGOffset] or
  /// [DAGSize], and returns true if both the horizontal and vertical values of the
  /// left-hand-side operand are smaller than the horizontal and vertical values
  /// of the right-hand-side operand respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator <(OffsetBase other) => _dx < other._dx && _dy < other._dy;

  /// Less-than-or-equal-to operator. Compares an [DAGOffset] or [DAGSize] to another
  /// [DAGOffset] or [DAGSize], and returns true if both the horizontal and vertical
  /// values of the left-hand-side operand are smaller than or equal to the
  /// horizontal and vertical values of the right-hand-side operand
  /// respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator <=(OffsetBase other) => _dx <= other._dx && _dy <= other._dy;

  /// Greater-than operator. Compares an [DAGOffset] or [DAGSize] to another [DAGOffset]
  /// or [DAGSize], and returns true if both the horizontal and vertical values of
  /// the left-hand-side operand are bigger than the horizontal and vertical
  /// values of the right-hand-side operand respectively. Returns false
  /// otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator >(OffsetBase other) => _dx > other._dx && _dy > other._dy;

  /// Greater-than-or-equal-to operator. Compares an [DAGOffset] or [DAGSize] to
  /// another [DAGOffset] or [DAGSize], and returns true if both the horizontal and
  /// vertical values of the left-hand-side operand are bigger than or equal to
  /// the horizontal and vertical values of the right-hand-side operand
  /// respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator >=(OffsetBase other) => _dx >= other._dx && _dy >= other._dy;

  /// Equality operator. Compares an [DAGOffset] or [DAGSize] to another [DAGOffset] or
  /// [DAGSize], and returns true if the horizontal and vertical values of the
  /// left-hand-side operand are equal to the horizontal and vertical values of
  /// the right-hand-side operand respectively. Returns false otherwise.
  @override
  bool operator ==(Object other) {
    return other is OffsetBase && other._dx == _dx && other._dy == _dy;
  }

  @override
  String toString() =>
      'OffsetBase(${_dx.toStringAsFixed(1)}, ${_dy.toStringAsFixed(1)})';
}

/// An immutable 2D floating-point offset.
///
/// Generally speaking, Offsets can be interpreted in two ways:
///
/// 1. As representing a point in Cartesian space a specified distance from a
///    separately-maintained origin. For example, the top-left position of
///    children in the [RenderBox] protocol is typically represented as an
///    [DAGOffset] from the top left of the parent box.
///
/// 2. As a vector that can be applied to coordinates. For example, when
///    painting a [RenderObject], the parent is passed an [DAGOffset] from the
///    screen's origin which it can add to the offsets of its children to find
///    the [DAGOffset] from the screen's origin to each of the children.
///
/// Because a particular [DAGOffset] can be interpreted as one sense at one time
/// then as the other sense at a later time, the same class is used for both
/// senses.
///
/// See also:
///
///  * [DAGSize], which represents a vector describing the size of a rectangle.
class DAGOffset extends OffsetBase {
  /// Creates an offset. The first argument sets [dx], the horizontal component,
  /// and the second sets [dy], the vertical component.
  const DAGOffset(double dx, double dy) : super(dx, dy);

  /// Creates an offset from its [direction] and [distance].
  ///
  /// The direction is in radians clockwise from the positive x-axis.
  ///
  /// The distance can be omitted, to create a unit vector (distance = 1.0).
  factory DAGOffset.fromDirection(double direction, [double distance = 1.0]) {
    return DAGOffset(
        distance * math.cos(direction), distance * math.sin(direction));
  }

  /// The x component of the offset.
  ///
  /// The y component is given by [dy].
  double get dx => _dx;

  /// The y component of the offset.
  ///
  /// The x component is given by [dx].
  double get dy => _dy;

  /// The magnitude of the offset.
  ///
  /// If you need this value to compare it to another [DAGOffset]'s distance,
  /// consider using [distanceSquared] instead, since it is cheaper to compute.
  double get distance => math.sqrt(dx * dx + dy * dy);

  /// The square of the magnitude of the offset.
  ///
  /// This is cheaper than computing the [distance] itself.
  double get distanceSquared => dx * dx + dy * dy;

  /// The angle of this offset as radians clockwise from the positive x-axis, in
  /// the range -[pi] to [pi], assuming positive values of the x-axis go to the
  /// right and positive values of the y-axis go down.
  ///
  /// Zero means that [dy] is zero and [dx] is zero or positive.
  ///
  /// Values from zero to [pi]/2 indicate positive values of [dx] and [dy], the
  /// bottom-right quadrant.
  ///
  /// Values from [pi]/2 to [pi] indicate negative values of [dx] and positive
  /// values of [dy], the bottom-left quadrant.
  ///
  /// Values from zero to -[pi]/2 indicate positive values of [dx] and negative
  /// values of [dy], the top-right quadrant.
  ///
  /// Values from -[pi]/2 to -[pi] indicate negative values of [dx] and [dy],
  /// the top-left quadrant.
  ///
  /// When [dy] is zero and [dx] is negative, the [direction] is [pi].
  ///
  /// When [dx] is zero, [direction] is [pi]/2 if [dy] is positive and -[pi]/2
  /// if [dy] is negative.
  ///
  /// See also:
  ///
  ///  * [distance], to compute the magnitude of the vector.
  ///  * [Canvas.rotate], which uses the same convention for its angle.
  double get direction => math.atan2(dy, dx);

  /// An offset with zero magnitude.
  ///
  /// This can be used to represent the origin of a coordinate space.
  static const DAGOffset zero = DAGOffset(0.0, 0.0);

  /// An offset with infinite x and y components.
  ///
  /// See also:
  ///
  ///  * [isInfinite], which checks whether either component is infinite.
  ///  * [isFinite], which checks whether both components are finite.
  // This is included for completeness, because [Size.infinite] exists.
  static const DAGOffset infinite = DAGOffset(double.infinity, double.infinity);

  /// Returns a new offset with the x component scaled by `scaleX` and the y
  /// component scaled by `scaleY`.
  ///
  /// If the two scale arguments are the same, consider using the `*` operator
  /// instead:
  ///
  /// ```dart
  /// Offset a = const Offset(10.0, 10.0);
  /// Offset b = a * 2.0; // same as: a.scale(2.0, 2.0)
  /// ```
  ///
  /// If the two arguments are -1, consider using the unary `-` operator
  /// instead:
  ///
  /// ```dart
  /// Offset a = const Offset(10.0, 10.0);
  /// Offset b = -a; // same as: a.scale(-1.0, -1.0)
  /// ```
  DAGOffset scale(double scaleX, double scaleY) =>
      DAGOffset(dx * scaleX, dy * scaleY);

  /// Returns a new offset with translateX added to the x component and
  /// translateY added to the y component.
  ///
  /// If the arguments come from another [DAGOffset], consider using the `+` or `-`
  /// operators instead:
  ///
  /// ```dart
  /// Offset a = const Offset(10.0, 10.0);
  /// Offset b = const Offset(10.0, 10.0);
  /// Offset c = a + b; // same as: a.translate(b.dx, b.dy)
  /// Offset d = a - b; // same as: a.translate(-b.dx, -b.dy)
  /// ```
  DAGOffset translate(double translateX, double translateY) =>
      DAGOffset(dx + translateX, dy + translateY);

  /// Unary negation operator.
  ///
  /// Returns an offset with the coordinates negated.
  ///
  /// If the [DAGOffset] represents an arrow on a plane, this operator returns the
  /// same arrow but pointing in the reverse direction.
  DAGOffset operator -() => DAGOffset(-dx, -dy);

  /// Binary subtraction operator.
  ///
  /// Returns an offset whose [dx] value is the left-hand-side operand's [dx]
  /// minus the right-hand-side operand's [dx] and whose [dy] value is the
  /// left-hand-side operand's [dy] minus the right-hand-side operand's [dy].
  ///
  /// See also [translate].
  DAGOffset operator -(DAGOffset other) =>
      DAGOffset(dx - other.dx, dy - other.dy);

  /// Binary addition operator.
  ///
  /// Returns an offset whose [dx] value is the sum of the [dx] values of the
  /// two operands, and whose [dy] value is the sum of the [dy] values of the
  /// two operands.
  ///
  /// See also [translate].
  DAGOffset operator +(DAGOffset other) =>
      DAGOffset(dx + other.dx, dy + other.dy);

  /// Multiplication operator.
  ///
  /// Returns an offset whose coordinates are the coordinates of the
  /// left-hand-side operand (an Offset) multiplied by the scalar
  /// right-hand-side operand (a double).
  ///
  /// See also [scale].
  DAGOffset operator *(double operand) => DAGOffset(dx * operand, dy * operand);

  /// Division operator.
  ///
  /// Returns an offset whose coordinates are the coordinates of the
  /// left-hand-side operand (an Offset) divided by the scalar right-hand-side
  /// operand (a double).
  ///
  /// See also [scale].
  DAGOffset operator /(double operand) => DAGOffset(dx / operand, dy / operand);

  /// Integer (truncating) division operator.
  ///
  /// Returns an offset whose coordinates are the coordinates of the
  /// left-hand-side operand (an Offset) divided by the scalar right-hand-side
  /// operand (a double), rounded towards zero.
  DAGOffset operator ~/(double operand) =>
      DAGOffset((dx ~/ operand).toDouble(), (dy ~/ operand).toDouble());

  /// Modulo (remainder) operator.
  ///
  /// Returns an offset whose coordinates are the remainder of dividing the
  /// coordinates of the left-hand-side operand (an Offset) by the scalar
  /// right-hand-side operand (a double).
  DAGOffset operator %(double operand) => DAGOffset(dx % operand, dy % operand);

  /// Linearly interpolate between two offsets.
  ///
  /// If either offset is null, this function interpolates from [DAGOffset.zero].
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [DAGCurves.elasticInOut]).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  static DAGOffset? lerp(DAGOffset? a, DAGOffset? b, double t) {
    assert(t != null);
    if (b == null) {
      if (a == null) {
        return null;
      } else {
        return a * (1.0 - t);
      }
    } else {
      if (a == null) {
        return b * t;
      } else {
        return DAGOffset(
            _lerpDouble(a.dx, b.dx, t), _lerpDouble(a.dy, b.dy, t));
      }
    }
  }

  /// Compares two Offsets for equality.
  @override
  bool operator ==(Object other) {
    return other is DAGOffset && other.dx == dx && other.dy == dy;
  }

  @override
  int get hashCode => hashValues(dx, dy);

  @override
  String toString() =>
      'Offset(${dx.toStringAsFixed(1)}, ${dy.toStringAsFixed(1)})';
}

/// Holds a 2D floating-point size.
///
/// You can think of this as an [DAGOffset] from the origin.
class DAGSize extends OffsetBase {
  /// Creates a [DAGSize] with the given [width] and [height].
  const DAGSize(double width, double height) : super(width, height);

  /// Creates an instance of [DAGSize] that has the same values as another.
  // Used by the rendering library's _DebugSize hack.
  DAGSize.copy(DAGSize source) : super(source.width, source.height);

  /// Creates a square [DAGSize] whose [width] and [height] are the given dimension.
  ///
  /// See also:
  ///
  ///  * [Size.fromRadius], which is more convenient when the available size
  ///    is the radius of a circle.
  const DAGSize.square(double dimension) : super(dimension, dimension);

  /// Creates a [DAGSize] with the given [width] and an infinite [height].
  const DAGSize.fromWidth(double width) : super(width, double.infinity);

  /// Creates a [DAGSize] with the given [height] and an infinite [width].
  const DAGSize.fromHeight(double height) : super(double.infinity, height);

  /// Creates a square [DAGSize] whose [width] and [height] are twice the given
  /// dimension.
  ///
  /// This is a square that contains a circle with the given radius.
  ///
  /// See also:
  ///
  ///  * [Size.square], which creates a square with the given dimension.
  const DAGSize.fromRadius(double radius) : super(radius * 2.0, radius * 2.0);

  /// The horizontal extent of this size.
  double get width => _dx;

  /// The vertical extent of this size.
  double get height => _dy;

  /// The aspect ratio of this size.
  ///
  /// This returns the [width] divided by the [height].
  ///
  /// If the [width] is zero, the result will be zero. If the [height] is zero
  /// (and the [width] is not), the result will be [double.infinity] or
  /// [double.negativeInfinity] as determined by the sign of [width].
  ///
  /// See also:
  ///
  ///  * [AspectRatio], a widget for giving a child widget a specific aspect
  ///    ratio.
  ///  * [FittedBox], a widget that (in most modes) attempts to maintain a
  ///    child widget's aspect ratio while changing its size.
  double get aspectRatio {
    if (height != 0.0) return width / height;
    if (width > 0.0) return double.infinity;
    if (width < 0.0) return double.negativeInfinity;
    return 0.0;
  }

  /// An empty size, one with a zero width and a zero height.
  static const DAGSize zero = DAGSize(0.0, 0.0);

  /// A size whose [width] and [height] are infinite.
  ///
  /// See also:
  ///
  ///  * [isInfinite], which checks whether either dimension is infinite.
  ///  * [isFinite], which checks whether both dimensions are finite.
  static const DAGSize infinite = DAGSize(double.infinity, double.infinity);

  /// Whether this size encloses a non-zero area.
  ///
  /// Negative areas are considered empty.
  bool get isEmpty => width <= 0.0 || height <= 0.0;

  /// Binary subtraction operator for [DAGSize].
  ///
  /// Subtracting a [DAGSize] from a [DAGSize] returns the [DAGOffset] that describes how
  /// much bigger the left-hand-side operand is than the right-hand-side
  /// operand. Adding that resulting [DAGOffset] to the [DAGSize] that was the
  /// right-hand-side operand would return a [DAGSize] equal to the [DAGSize] that was
  /// the left-hand-side operand. (i.e. if `sizeA - sizeB -> offsetA`, then
  /// `offsetA + sizeB -> sizeA`)
  ///
  /// Subtracting an [DAGOffset] from a [DAGSize] returns the [DAGSize] that is smaller than
  /// the [DAGSize] operand by the difference given by the [DAGOffset] operand. In other
  /// words, the returned [DAGSize] has a [width] consisting of the [width] of the
  /// left-hand-side operand minus the [DAGOffset.dx] dimension of the
  /// right-hand-side operand, and a [height] consisting of the [height] of the
  /// left-hand-side operand minus the [DAGOffset.dy] dimension of the
  /// right-hand-side operand.
  OffsetBase operator -(OffsetBase other) {
    if (other is DAGSize)
      return DAGOffset(width - other.width, height - other.height);
    if (other is DAGOffset) return DAGSize(width - other.dx, height - other.dy);
    throw ArgumentError(other);
  }

  /// Binary addition operator for adding an [DAGOffset] to a [DAGSize].
  ///
  /// Returns a [DAGSize] whose [width] is the sum of the [width] of the
  /// left-hand-side operand, a [DAGSize], and the [DAGOffset.dx] dimension of the
  /// right-hand-side operand, an [DAGOffset], and whose [height] is the sum of the
  /// [height] of the left-hand-side operand and the [DAGOffset.dy] dimension of
  /// the right-hand-side operand.
  DAGSize operator +(DAGOffset other) =>
      DAGSize(width + other.dx, height + other.dy);

  /// Multiplication operator.
  ///
  /// Returns a [DAGSize] whose dimensions are the dimensions of the left-hand-side
  /// operand (a [DAGSize]) multiplied by the scalar right-hand-side operand (a
  /// [double]).
  DAGSize operator *(double operand) =>
      DAGSize(width * operand, height * operand);

  /// Division operator.
  ///
  /// Returns a [DAGSize] whose dimensions are the dimensions of the left-hand-side
  /// operand (a [DAGSize]) divided by the scalar right-hand-side operand (a
  /// [double]).
  DAGSize operator /(double operand) =>
      DAGSize(width / operand, height / operand);

  /// Integer (truncating) division operator.
  ///
  /// Returns a [DAGSize] whose dimensions are the dimensions of the left-hand-side
  /// operand (a [DAGSize]) divided by the scalar right-hand-side operand (a
  /// [double]), rounded towards zero.
  DAGSize operator ~/(double operand) =>
      DAGSize((width ~/ operand).toDouble(), (height ~/ operand).toDouble());

  /// Modulo (remainder) operator.
  ///
  /// Returns a [DAGSize] whose dimensions are the remainder of dividing the
  /// left-hand-side operand (a [DAGSize]) by the scalar right-hand-side operand (a
  /// [double]).
  DAGSize operator %(double operand) =>
      DAGSize(width % operand, height % operand);

  /// The lesser of the magnitudes of the [width] and the [height].
  double get shortestSide => math.min(width.abs(), height.abs());

  /// The greater of the magnitudes of the [width] and the [height].
  double get longestSide => math.max(width.abs(), height.abs());

  // Convenience methods that do the equivalent of calling the similarly named
  // methods on a Rect constructed from the given origin and this size.

  /// The offset to the intersection of the top and left edges of the rectangle
  /// described by the given [DAGOffset] (which is interpreted as the top-left corner)
  /// and this [DAGSize].
  ///
  /// See also [Rect.topLeft].
  DAGOffset topLeft(DAGOffset origin) => origin;

  /// The offset to the center of the top edge of the rectangle described by the
  /// given offset (which is interpreted as the top-left corner) and this size.
  ///
  /// See also [Rect.topCenter].
  DAGOffset topCenter(DAGOffset origin) =>
      DAGOffset(origin.dx + width / 2.0, origin.dy);

  /// The offset to the intersection of the top and right edges of the rectangle
  /// described by the given offset (which is interpreted as the top-left corner)
  /// and this size.
  ///
  /// See also [Rect.topRight].
  DAGOffset topRight(DAGOffset origin) =>
      DAGOffset(origin.dx + width, origin.dy);

  /// The offset to the center of the left edge of the rectangle described by the
  /// given offset (which is interpreted as the top-left corner) and this size.
  ///
  /// See also [Rect.centerLeft].
  DAGOffset centerLeft(DAGOffset origin) =>
      DAGOffset(origin.dx, origin.dy + height / 2.0);

  /// The offset to the point halfway between the left and right and the top and
  /// bottom edges of the rectangle described by the given offset (which is
  /// interpreted as the top-left corner) and this size.
  ///
  /// See also [Rect.center].
  DAGOffset center(DAGOffset origin) =>
      DAGOffset(origin.dx + width / 2.0, origin.dy + height / 2.0);

  /// The offset to the center of the right edge of the rectangle described by the
  /// given offset (which is interpreted as the top-left corner) and this size.
  ///
  /// See also [Rect.centerLeft].
  DAGOffset centerRight(DAGOffset origin) =>
      DAGOffset(origin.dx + width, origin.dy + height / 2.0);

  /// The offset to the intersection of the bottom and left edges of the
  /// rectangle described by the given offset (which is interpreted as the
  /// top-left corner) and this size.
  ///
  /// See also [Rect.bottomLeft].
  DAGOffset bottomLeft(DAGOffset origin) =>
      DAGOffset(origin.dx, origin.dy + height);

  /// The offset to the center of the bottom edge of the rectangle described by
  /// the given offset (which is interpreted as the top-left corner) and this
  /// size.
  ///
  /// See also [Rect.bottomLeft].
  DAGOffset bottomCenter(DAGOffset origin) =>
      DAGOffset(origin.dx + width / 2.0, origin.dy + height);

  /// The offset to the intersection of the bottom and right edges of the
  /// rectangle described by the given offset (which is interpreted as the
  /// top-left corner) and this size.
  ///
  /// See also [Rect.bottomRight].
  DAGOffset bottomRight(DAGOffset origin) =>
      DAGOffset(origin.dx + width, origin.dy + height);

  /// Whether the point specified by the given offset (which is assumed to be
  /// relative to the top left of the size) lies between the left and right and
  /// the top and bottom edges of a rectangle of this size.
  ///
  /// Rectangles include their top and left edges but exclude their bottom and
  /// right edges.
  bool contains(DAGOffset offset) {
    return offset.dx >= 0.0 &&
        offset.dx < width &&
        offset.dy >= 0.0 &&
        offset.dy < height;
  }

  /// A [DAGSize] with the [width] and [height] swapped.
  DAGSize get flipped => DAGSize(height, width);

  /// Linearly interpolate between two sizes
  ///
  /// If either size is null, this function interpolates from [DAGSize.zero].
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [DAGCurves.elasticInOut]).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  static DAGSize? lerp(DAGSize? a, DAGSize? b, double t) {
    assert(t != null);
    if (b == null) {
      if (a == null) {
        return null;
      } else {
        return a * (1.0 - t);
      }
    } else {
      if (a == null) {
        return b * t;
      } else {
        return DAGSize(_lerpDouble(a.width, b.width, t),
            _lerpDouble(a.height, b.height, t));
      }
    }
  }

  /// Compares two Sizes for equality.
  // We don't compare the runtimeType because of _DebugSize in the framework.
  @override
  bool operator ==(Object other) {
    return other is DAGSize && other._dx == _dx && other._dy == _dy;
  }

  @override
  int get hashCode => hashValues(_dx, _dy);

  @override
  String toString() =>
      'Size(${width.toStringAsFixed(1)}, ${height.toStringAsFixed(1)})';
}
