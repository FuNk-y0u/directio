import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:route_app/apis/newapi.dart';
import 'package:route_app/components/newscomponent.dart';
import 'package:route_app/config.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:weather/weather.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newsApi = NewsApi(NEWSCOUNTRY, NEWSTOKEN); // News fetch api
  final WeatherFactory weatherApi =
      WeatherFactory(WEATHERTOKEN); // Weather fetch api

  BottomDrawerController bottomDrawerController =
      BottomDrawerController(); // Bottom Qr Code Drawer

  // ignore: prefer_typing_uninitialized_variables
  var articles; // List of all the top articles
  bool showQr = false; // Showing qr drawers

  // Current article stuff
  var currentArticleTitle = '';
  var currentArticleLink = '';

  // Weather stuff
  String weatherTemp = "";
  String weatherDescription = "";

  // Weather fetch function
  void fetchWeather() {
    Future weatherData = weatherApi.currentWeatherByCityName(WEATHERCITYNAME);

    weatherData.then((value) {
      Weather weatherData = value;

      if (mounted) {
        setState(() {
          weatherTemp = weatherData.tempFeelsLike!.celsius!.toStringAsFixed(2);
          weatherDescription = weatherData.weatherDescription ?? "N/A";
        });
      }
    });
  }

  // Datetime variables
  String formattedTime =
      DateFormat('kk:mm').format(DateTime.now()); // Gives time in hh:mm format
  String formattedDate =
      DateFormat('dd MMM').format(DateTime.now()); // Gives date in dd MM format
  Duration dateTimeUpdateDuration =
      const Duration(seconds: 1); // Update Time for time

  // Updating time
  void updateTime(Timer time) {
    if (mounted) {
      setState(() {
        formattedTime = DateFormat('kk:mm').format(DateTime.now());
      });
    }
  }

  // Runs when app initialized
  // 1. Fetches news
  // 2. Fetches weather
  // 3. Updates time
  @override
  void initState() {
    if (mounted) {
      super.initState();
      // Fetcing news
      newsApi.fetchNews((value) {
        if (value.statusCode == 200) {
          if (mounted) {
            setState(() {
              articles = Future.value(value);
            });
          }
        }
      });

      // Fetching weather description and data
      fetchWeather();

      // Updating time every second
      Timer.periodic(dateTimeUpdateDuration, updateTime);
    }
  }

  Widget dragAbleScrollableSheet() {
    return DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(color: Colors.black);
      },
    );
  }

  Widget newsListView(snapshot) {
    if (snapshot.hasData) {
      var articles = jsonDecode(snapshot.data.body)["articles"];
      return RefreshIndicator(
          child: GridView.count(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            crossAxisCount: 3,
            children: List.generate(articles.length, (index) {
              var article = articles[index];
              return newsComponent(context, article, () {
                setState(() {
                  currentArticleTitle = article['title'];
                  currentArticleLink = article['url'];
                });
                bottomDrawerController.open();
              });
            }),
          ),
          onRefresh: () async {
            newsApi.fetchNews((value) {
              if (value.statusCode == 200) {
                if (mounted) {
                  setState(() {
                    articles = Future.value(value);
                  });
                }
              }
            });
          });
    } else if (snapshot.hasError) {
      return Text(snapshot.error.toString());
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(children: [
        introBar(),
        Expanded(
          child: FutureBuilder(
            future: articles,
            builder: (context, snapshot) => newsListView(snapshot),
          ),
        ),
      ]),
      bottomDrawer()
    ]));
  }

  SizedBox introBar() {
    return SizedBox(
      width: 1200,
      height: 250,
      child: Center(
          child: Column(children: [
        const Spacer(),
        const Text(
          "Welcome to bus park",
          style: TextStyle(fontSize: 32),
        ),
        Row(
          children: [
            const Spacer(),
            Text(
              "$weatherTemp°C",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
            const Spacer()
          ],
        ),
        Text(
          "$weatherDescription • $formattedTime • $formattedDate",
          style: const TextStyle(fontSize: 20),
        )
      ])),
    );
  }

  BottomDrawer bottomDrawer() {
    return BottomDrawer(
        color: const Color.fromARGB(255, 235, 235, 235),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 60,
              spreadRadius: 5,
              offset: const Offset(2, -6))
        ],
        header: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              width: 900,
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Column(
                  children: [
                    const Text(
                      "Read more here",
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      currentArticleTitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 119, 218),
                      width: 10)),
              child: QrImageView(
                data: currentArticleLink,
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 200,
                child: TextButton(
                    onPressed: () => {bottomDrawerController.close()},
                    child: const Icon(Icons.check)),
              ),
            )
          ],
        ),
        headerHeight: 0.0,
        drawerHeight: 500.0,
        controller: bottomDrawerController);
  }
}
