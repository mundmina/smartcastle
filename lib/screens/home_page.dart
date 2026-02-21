import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_weather/providers/weather_provider.dart';
import 'package:smart_weather/screens/search_page.dart';
import 'package:smart_weather/widgets/weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather("Almaty");
    });
  }

  Color _getBackgroundColor(double temp) {
    if (temp <= 0) return Colors.blue.shade900;
    if (temp <= 15) return Colors.blue;
    if (temp <= 25) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          color: provider.weather == null
              ? Colors.grey
              : _getBackgroundColor(provider.weather!.temperature),
          child: Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: provider.isLoading
                  ? CircularProgressIndicator()
                  : provider.error != null
                  ? Text(provider.error!)
                  : WeatherCard(weatherModel: provider.weather!),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
        child: Icon(Icons.search),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secAnimation) {
        return SearchPage();
      },
      transitionsBuilder: (context, animation, secAnimation, widget) {
        final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

        return FadeTransition(opacity: fade, child: widget);
      },
    );
  }
}
