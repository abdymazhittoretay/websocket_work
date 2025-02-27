import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse(
      'wss://echo.websocket.events',
    ), // just used to send and retrieve the data (example)
  );
  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Add your text here"),
                ),
              ),
              SizedBox(height: 16.0),
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData &&
                            snapshot.data !=
                                "echo.websocket.events sponsored by Lob.com"
                        ? "Your text:\n${snapshot.data}"
                        : "",
                    style: TextStyle(fontSize: 24.0),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.text.isNotEmpty) {
            _channel.sink.add(_controller.text);
            _controller.clear();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
