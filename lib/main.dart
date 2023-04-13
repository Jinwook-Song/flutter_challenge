import 'package:flutter/material.dart';

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
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade900,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  static const _days = [
    'TODAY',
    '•',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    radius: 28,
                    foregroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/78011042?v=4',
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('MONDAY 16'),
                const SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 36,
                  child: ListView.separated(
                    itemCount: _days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Text(
                        _days[index],
                        style: TextStyle(
                          fontSize: 36,
                          color: index == 0
                              ? Colors.white
                              : index == 1
                                  ? Colors.pink.shade700
                                  : Colors.white.withOpacity(0.4),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: const [
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
                  )),
            )
          ],
        ),
      ),
    );
  }
}
