import 'package:flutter/material.dart';
import 'package:smart_weather/models/forecast_model.dart';
import 'package:smart_weather/models/weather_model.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({
    super.key,
    required this.weatherModel,
    required this.forecast,
  });

  final WeatherModel weatherModel;
  final List<ForecastModel> forecast;

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _slide = Tween(
      begin: Offset(0, 0.5),
      end: Offset(0, 0),
    ).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.weatherModel.cityName),
              Text('${widget.weatherModel.temperature} C'),
              Image.network(
                'https://openweathermap.org/img/wn/${widget.weatherModel.icon}@2x.png',
              ),
              Text(widget.weatherModel.description),
              Text('Влажность: ${widget.weatherModel.humidity}'),
              Text('Скорость ветра: ${widget.weatherModel.windSpeed}'),
              SizedBox(height: 20),
              Text('Прогноз погоды на 5 дней'),
              SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: widget.forecast.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final day = widget.forecast[index];
                    return Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(day.date.substring(5, 10)),
                          Image.network(
                            'https://openweathermap.org/img/wn/${day.icon}@2x.png',
                            width: 40,
                          ),
                          Text('${day.temperature.toInt()} C'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
