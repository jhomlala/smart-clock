/// Model used for location digital clocks
class Location {
  /// Name of the location
  final String name;

  ///Time offset in GMT system
  final int timeOffset;

  Location(this.name, this.timeOffset)
      : assert(name != null && name.length > 0, "Name can't be null"),
        assert(timeOffset >= -12 && timeOffset <= 12,
            "Time offset must be between -12 and 12");
}
