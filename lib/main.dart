import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word-by-Word Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WordReader(),
    );
  }
}

class WordReader extends StatefulWidget {
  const WordReader({Key? key}) : super(key: key);

  @override
  _WordReaderState createState() => _WordReaderState();
}

class _WordReaderState extends State<WordReader> {
  final TextEditingController _textController = TextEditingController();
  List<String> _words = [];
  int _currentIndex = 0;
  Timer? _timer;
  bool _isPlaying = false;
  int _speed = 500; // Default speed in milliseconds

  void _startReading() {
    _stopReading();
    _timer = Timer.periodic(Duration(milliseconds: _speed), (timer) {
      if (_currentIndex < _words.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _stopReading(); // Stop at the end of text
      }
    });
    setState(() {
      _isPlaying = true;
    });
  }

  void _stopReading() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _nextWord() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousWord() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _resetReader() {
    _stopReading();
    setState(() {
      _currentIndex = 0;
    });
  }

  void _loadText() {
    _words = _textController.text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    _resetReader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word-by-Word Reader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Enter text to read',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _loadText(),
            ),
            const SizedBox(height: 20),
            Text(
              _words.isNotEmpty ? _words[_currentIndex] : 'Enter text to start',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text('Word ${_currentIndex + 1} of ${_words.length}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _previousWord,
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Previous word',
                ),
                IconButton(
                  onPressed: _isPlaying ? _stopReading : _startReading,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  tooltip: _isPlaying ? 'Pause' : 'Play',
                ),
                IconButton(
                  onPressed: _nextWord,
                  icon: const Icon(Icons.arrow_forward),
                  tooltip: 'Next word',
                ),
                IconButton(
                  onPressed: _resetReader,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Speed (ms):'),
                Expanded(
                  child: Slider(
                    min: 100,
                    max: 1000,
                    value: _speed.toDouble(),
                    divisions: 18,
                    label: _speed.toString(),
                    onChanged: (value) {
                      setState(() {
                        _speed = value.toInt();
                        if (_isPlaying) {
                          _startReading(); // Restart with updated speed
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
