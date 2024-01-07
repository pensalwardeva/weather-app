import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testweather/weather%20forecast%20item.dart';
import 'additional info item.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App',
      // theme: lightTheme,
      // darkTheme: darkTheme,
      home: WeatherScreen(),
    );
  }
}
//
// final ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primarySwatch: Colors.blue,
//   hintColor: Colors.blueAccent,
// );
//
// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primarySwatch: Colors.teal,
//   hintColor: Colors.tealAccent,
// );

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late List<String> cities;
  late Map<String, List<dynamic>> weatherData;
  String? selectedCity;

  String? city;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cities = ['Pune'];
    weatherData = {};
    selectedCity = null;

    // Fetch weather data for the default cities
    for (var city in cities) {
      getCurrentWeather(city);
    }

    // Request location permission when the screen initializes
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.location.request();
    }
  }

  Future<void> getCurrentWeather(String cityName) async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=e13ab72bfa28d25f5b61a8bd16157c28'));

      final data = jsonDecode(res.body);

      if (data['cod'] == '200') {
        setState(() {
          weatherData[cityName] = data['list'];
          selectedCity = cityName;
        });
      } else {
        throw 'Error: ${data['message']}';
      }
    } catch (e) {
      handleErrors(e.toString());
    }
  }

  void handleErrors(String errorMessage) {
    // Show toast message based on the error type
    if (errorMessage.contains('location')) {
      showToast('Location permission denied');
    } else if (errorMessage.contains('Internet')) {
      showToast('Check your internet connection');
    } else {
      showToast('Error fetching data: $errorMessage');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  String _formatTemperature(double kelvinTemp) {
    double celsiusTemp = kelvinTemp - 273.15; // Convert Kelvin to Celsius
    return '${celsiusTemp.round()}°C';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: textEditingController,
                  onSubmitted: (value) {
                    setState(() {
                      city = value;
                    });
                    getWeather();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a city',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          city = textEditingController.text;
                        });
                        getWeather();
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              if (selectedCity != null && weatherData.containsKey(selectedCity))
                buildCityWeatherCard(selectedCity!, weatherData[selectedCity]!),
            ],
          ),
        )
    );
  }

  Future<void> getWeather() async {
    if (city != null && city!.isNotEmpty) {
      await getCurrentWeather(city!);
      textEditingController.clear(); // Clear the text field after search
    }
  }

  Widget buildCityWeatherCard(String cityName, List<dynamic> data) {
    final currentWeatherData = data[0];

    final currentTemp = currentWeatherData['main']['temp'];
    final currentSky = currentWeatherData['weather'][0]['main'];
    final currentPressure = currentWeatherData['main']['pressure'];
    final currentWindSpeed = currentWeatherData['wind']['speed'];
    final currentHumidity = currentWeatherData['main']['humidity'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cityName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _formatTemperature(currentTemp),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Icon(
                          currentSky == 'Clouds' || currentSky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentSky,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hourly Forecast',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final hourlyForecast = data[index + 1];
                final hourlySky = hourlyForecast['weather'][0]['main'];
                final hourlyTemp = hourlyForecast['main']['temp'].toString();
                final time = DateTime.parse(hourlyForecast['dt_txt']);
                return HourlyForecastItem(
                  time: DateFormat.j().format(time),
                  temperature: _formatTemperature(double.parse(hourlyTemp)),
                  icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                      ? Icons.cloud
                      : Icons.sunny,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdditionalInfoItem(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: currentHumidity.toString(),
              ),
              AdditionalInfoItem(
                icon: Icons.air,
                label: 'Wind Speed',
                value: currentWindSpeed.toString(),
              ),
              AdditionalInfoItem(
                icon: Icons.beach_access,
                label: 'Pressure',
                value: currentPressure.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}