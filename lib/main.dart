import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scrollable Web',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final colors = Colors.primaries.toList()..shuffle();
  final indexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topNavigation(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _topNavigation() => Container(
        color: Colors.white,
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            for (int i = 0; i < colors.length; i++)
              Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => indexNotifier.value = i);
                    },
                    child: Text("$i"),
                  )),
          ],
        ),
      );

  Widget _list() => MyListView(colors: colors, indexNotifier: indexNotifier);
}

class MyListView extends StatefulWidget {
  const MyListView({
    Key key,
    @required this.indexNotifier,
    @required this.colors,
  }) : super(key: key);

  final List<MaterialColor> colors;
  final ValueNotifier<int> indexNotifier;

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> with WidgetsBindingObserver {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    widget.indexNotifier.addListener(() {
      _scrollController.jumpTo(
        widget.indexNotifier.value * _itemHeight,
      );
    });
    super.initState();
  }

  double get _itemHeight => _scrollController.position.viewportDimension;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.colors.length,
      itemBuilder: (BuildContext context, int index) {
        final color = widget.colors[index];
        return Container(
          height: _itemHeight,
          color: color.shade100,
          child: Center(child: Text("index: $index", style: Theme.of(context).textTheme.headline1)),
        );
      },
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_scrollController.hasClients) {
      print("changed size ${_scrollController.position.viewportDimension}");
      setState(() {});
    }
  }
}
