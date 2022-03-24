import 'package:flutter/material.dart';
import 'data_service.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UselessFactsPage(),
    ),
  );
}

class UselessFactsPage extends StatefulWidget {
  const UselessFactsPage({Key? key}) : super(key: key);

  @override
  State<UselessFactsPage> createState() => _UselessFactsPageState();
}

class _UselessFactsPageState extends State<UselessFactsPage>
    with WidgetsBindingObserver {
  final _dataService = DataService();
  var _todaysUselessFact = '';
  var _randomUselessFact = '';

  final gradientOfTheDay = const LinearGradient(colors: [
    Colors.purple,
    Colors.blue,
    Colors.cyan,
    Colors.green,
    Colors.yellow,
    Colors.red
  ]);

  final gradientRandom = const LinearGradient(colors: [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ]);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
    asyncInitState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _getRandomUselessFact(); // this calls setState
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance?.removeObserver(this);
  }

  void asyncInitState() async {
    final response = await _dataService.getUselessFacts('today');
    _todaysUselessFact = response.fact;

    _getRandomUselessFact(); // this calls setState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          GradientText(
              bannerText: 'Useless Fact of the Day',
              gradient: gradientOfTheDay),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: UselessText(
              uselessText: _todaysUselessFact,
            ),
          ),
          const SizedBox(height: 60),
          GradientText(
              bannerText: 'Useless Random Fact', gradient: gradientRandom),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: UselessText(
              uselessText: _randomUselessFact,
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            child: const Text(
              'Gimmee another...',
              style: TextStyle(fontSize: 22.0),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _getRandomUselessFact();
            },
          ),
        ],
      ),
    );
  }

  void _getRandomUselessFact() async {
    final response2 = await _dataService.getUselessFacts('random');

    setState(() => _randomUselessFact = response2.fact);
  }
}

class UselessText extends StatelessWidget {
  final String uselessText;

  const UselessText({Key? key, required this.uselessText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      uselessText,
      maxLines: 10,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String bannerText;
  final LinearGradient gradient;

  const GradientText(
      {Key? key, required this.bannerText, required this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return gradient.createShader(Offset.zero & bounds.size);
      },
      child: Center(
        child: Text(
          bannerText,
          style: const TextStyle(
            color: Colors.white, // has to be white text for shader to work
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
