import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const UiClone(),
    );
  }
}

class UiClone extends StatelessWidget {
  const UiClone({super.key});

  //   void _convertDateTimeToString(DateTime date) {
  //   final dateToString = date.toString().split(' ')[0];
  // }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formmatedDate = DateFormat('EEEE, d MMM, yyyy').format(date);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    radius: 30,
                    foregroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/78011042?v=4',
                    ),
                    child: Text('jw'),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  formmatedDate,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Text(
                        'TODAY',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        ' • ',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.pink),
                      ),
                      for (var day in [
                        16,
                        17,
                        18,
                        19,
                        20,
                        21,
                        22,
                        23,
                        24,
                        25
                      ]) ...[
                        Text(
                          '$day',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ]
                    ],
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                const Column(
                  children: [
                    Card(
                      date: ['11', '30', '12', '20'],
                      title: 'DESIGN\nMEETING',
                      people: ['ALEX', 'HELENA', 'NANA'],
                      color: Color.fromARGB(255, 249, 232, 47),
                    ),
                    SizedBox(height: 12),
                    Card(
                      date: ['12', '35', '14', '10'],
                      title: 'DAILY\nPROJECT',
                      people: ['ME', 'RICHARD', 'CIRY', '+4'],
                      color: Color.fromARGB(255, 218, 129, 233),
                    ),
                    SizedBox(height: 12),
                    Card(
                      date: ['15', '00', '16', '30'],
                      title: 'WEEKLY\nPLANNING',
                      people: ['DEN', 'NICO', 'JW'],
                      color: Color.fromARGB(255, 132, 254, 136),
                    ),
                    SizedBox(height: 12),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final List<String> date;
  final String title;
  final List<String> people;
  final Color color;

  const Card({
    Key? key,
    required this.date,
    required this.title,
    required this.people,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.black),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 30,
              child: Column(
                children: [
                  Text(
                    date[0],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    date[1],
                  ),
                  const Text(
                    '|',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Text(
                    date[2],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    date[3],
                  ),
                ],
              ),
            ),
            Positioned.fill(
              left: 60,
              top: 36,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 60,
                  letterSpacing: -1,
                  height: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(color: Colors.grey.shade700),
              child: Positioned(
                left: 80,
                bottom: 20,
                child: Row(
                  children: [
                    for (var person in people) ...[
                      Text(person),
                      const SizedBox(width: 24)
                    ]
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
