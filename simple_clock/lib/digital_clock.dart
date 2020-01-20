import 'package:flutter/material.dart';

class DigitalClock extends StatefulWidget {
  final Map _colors;
  final TextStyle _defaultStyle;
  final TextStyle _secondTextStyle;
  final String _amPmMarker;
  final String _time;
  final String _date;
  final String _weatherCondition;

  DigitalClock(
    this._colors,
    this._defaultStyle,
    this._secondTextStyle,
    this._amPmMarker,
    this._time,
    this._date,
    this._weatherCondition,
  );

  @override
  DigitalClockState createState() => new DigitalClockState();
}

class DigitalClockState extends State<DigitalClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: DefaultTextStyle(
          style: widget._defaultStyle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Semantics(
                label: 'Current time',
                container: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(widget._time),
                    DefaultTextStyle(
                      style: widget._secondTextStyle,
                      child: Container(
                        margin: widget._amPmMarker != ''
                            ? EdgeInsets.only(left: 5)
                            : null,
                        child: Text(widget._amPmMarker),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                transform: widget._amPmMarker == ''
                    ? Matrix4.translationValues(-5.0, -15.0, 0.0)
                    : null,
                child: DefaultTextStyle(
                  style: widget._secondTextStyle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      WeatherIcon(
                        iconColor: widget._colors['text'],
                        weatherCondition: widget._weatherCondition,
                      ),
                      Semantics(
                        label: 'Current date',
                        container: true,
                        child: Text(widget._date),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherIcon extends StatefulWidget {
  final String weatherCondition;
  final Color iconColor;

  WeatherIcon({
    this.weatherCondition,
    this.iconColor,
  });

  @override
  _WeatherIconState createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  @override
  Widget build(BuildContext context) {
    final weatherCondition = widget.weatherCondition;
    final iconColor = widget.iconColor;
    int iconCode;

    if (weatherCondition == 'cloudy') {
      iconCode = 0xe902;
    } else if (weatherCondition == 'foggy') {
      iconCode = 0xe916;
    } else if (weatherCondition == 'rainy') {
      iconCode = 0xe905;
    } else if (weatherCondition == 'snowy') {
      iconCode = 0xe908;
    } else if (weatherCondition == 'sunny') {
      iconCode = 0xe92c;
    } else if (weatherCondition == 'thunderstorm') {
      iconCode = 0xe918;
    } else if (weatherCondition == 'windy') {
      iconCode = 0xe93c;
    }

    return Semantics(
      label: 'Current weather',
      container: true,
      value: weatherCondition,
      child: Icon(
        IconData(iconCode, fontFamily: 'WeatherIconic'),
        size: 60,
        color: iconColor,
      ),
    );
  }
}
