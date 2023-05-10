import 'package:flutter/material.dart';

import 'models/page_link.dart';
import 'pages/bpm_page.dart';
import 'pages/records_page.dart';
import 'pages/graph_page.dart';
import 'widgets/drawer_header_widget.dart';
import 'widgets/page_link_list_tile_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/main',
      routes: {
        '/main': (context) => MainPage(body: const BPMPage(), title: 'BPM Page'),
        '/records': (context) => MainPage(body: const BpmRecordsPage(), title: 'Records Page'),
        '/graph': (context) => MainPage(body: const GraphPage(), title: 'Graph Page'),
      },
    );
  }
}



class MainPage extends StatelessWidget {
  final Widget body;
  final String title;

  MainPage({Key? key, required this.body, required this.title}) : super(key: key);

  final List<PageLink> pages = [
    const PageLink(
      icon: Icon(Icons.favorite),
      label: 'Main',
      route: '/main',
    ),
    const PageLink(
      icon: Icon(Icons.list_alt),
      label: 'Records',
      route: '/records',
    ),
    const PageLink(
      icon: Icon(Icons.show_chart),
      label: 'Graph',
      route: '/graph',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeaderWidget(),
            const SizedBox(height: 20),
            ...pages.map((page) => PageLinkListTileWidget(pageLink: page)).toList(),
          ],
        ),
      ),
      body: body,
    );
  }
}


