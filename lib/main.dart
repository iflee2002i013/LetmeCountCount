import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '进制转换器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final List<String> _messages = [
    '这是一个十分普通的应用。',
    '点击就会切换下一句对话。',
    '不信你可以试试。',
    '你看，是不是换了？',
    '再点也是一样的。',
    '你还不相信？',
    '好吧，这其实是一个计算器。',
  ];
  
  int _currentIndex = 0;

  void _nextMessage() {
    if (_currentIndex < _messages.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void _skipIntro() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('不想听我唠叨就直说~'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _nextMessage,
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  _messages[_currentIndex],
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 48,
              child: Center(
                child: TextButton(
                  onPressed: _skipIntro,
                  child: const Text(
                    '跳过',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _binaryController = TextEditingController();
  final _octalController = TextEditingController();
  final _decimalController = TextEditingController();
  final _hexController = TextEditingController();
  String _bitWidth = '';
  int? _activeBase; // 记录当前正在输入的进制

  @override
  void dispose() {
    _binaryController.dispose();
    _octalController.dispose();
    _decimalController.dispose();
    _hexController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String base) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('喂喂喂，会不会数数啊？$base进制怎么能输入这个值呢？'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateFromBinary(String value) {
    if (_activeBase != 2) return;
    if (value.isEmpty) {
      _clearAll();
      return;
    }
    
    if (value.contains(RegExp(r'[^0-1]'))) {
      _showErrorSnackBar('二');
      return;
    }
    
    try {
      final number = BigInt.parse(value, radix: 2);
      _updateAllFields(number, 2);
    } catch (_) {}
  }

  void _updateFromOctal(String value) {
    if (_activeBase != 8) return;
    if (value.isEmpty) {
      _clearAll();
      return;
    }
    
    if (value.contains(RegExp(r'[^0-7]'))) {
      _showErrorSnackBar('八');
      return;
    }
    
    try {
      final number = BigInt.parse(value, radix: 8);
      _updateAllFields(number, 8);
    } catch (_) {}
  }

  void _updateFromDecimal(String value) {
    if (_activeBase != 10) return;
    if (value.isEmpty) {
      _clearAll();
      return;
    }
    
    if (value.contains(RegExp(r'[^0-9]'))) {
      _showErrorSnackBar('十');
      return;
    }
    
    try {
      final number = BigInt.parse(value);
      _updateAllFields(number, 10);
    } catch (_) {}
  }

  void _updateFromHex(String value) {
    if (_activeBase != 16) return;
    if (value.isEmpty) {
      _clearAll();
      return;
    }
    
    if (value.contains(RegExp(r'[^0-9A-Fa-f]'))) {
      _showErrorSnackBar('十六');
      return;
    }
    
    try {
      final number = BigInt.parse(value, radix: 16);
      _updateAllFields(number, 16);
    } catch (_) {}
  }

  void _updateAllFields(BigInt number, int sourceBase) {
    setState(() {
      if (sourceBase != 2) {
        _binaryController.text = number.toRadixString(2);
      }
      if (sourceBase != 8) {
        _octalController.text = number.toRadixString(8);
      }
      if (sourceBase != 10) {
        _decimalController.text = number.toString();
      }
      if (sourceBase != 16) {
        _hexController.text = number.toRadixString(16).toUpperCase();
      }
      _bitWidth = '${number.toRadixString(2).length} 位';
      
      String message = '';
      switch (number.toString()) {
        case '1024':
          message = '程序员的进阶之路~';
          break;
        case '404':
          message = '咦？页面找不到了？';
          break;
        case '520':
          message = '爱你哟~';
          break;
        case '1314':
          message = '咦，肉麻~';
          break;
        case '250':
          message = '说谁250呢？';
          break;
        case '999':
          message = '够了够了，很纯了！';
          break;
        case '2048':
          message = '玩游戏呢？';
          break;
        case '37':
          message = '我叫三月七，不是37!';
          break;
      }
      
      if (message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.pink,
          ),
        );
      }
    });
  }

  void _clearAll() {
    setState(() {
      if (_activeBase != 2) _binaryController.clear();
      if (_activeBase != 8) _octalController.clear();
      if (_activeBase != 10) _decimalController.clear();
      if (_activeBase != 16) _hexController.clear();
      _bitWidth = '';
    });
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required int base,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            controller.clear();
            _clearAll();
          },
        ),
      ),
      onTap: () {
        setState(() => _activeBase = base);
      },
      onChanged: onChanged,
      readOnly: _activeBase != null && _activeBase != base,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('发现彩蛋！'),
                content: const Text('这是一个用Flutter写的进制转换器\n作者很懒，只写了这些功能'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('知道啦'),
                  ),
                ],
              ),
            );
          },
          child: const Text('进制转换器'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNumberField(
              label: '二进制',
              controller: _binaryController,
              base: 2,
              onChanged: _updateFromBinary,
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: '八进制',
              controller: _octalController,
              base: 8,
              onChanged: _updateFromOctal,
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: '十进制',
              controller: _decimalController,
              base: 10,
              onChanged: _updateFromDecimal,
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: '十六进制',
              controller: _hexController,
              base: 16,
              onChanged: _updateFromHex,
            ),
            if (_bitWidth.isNotEmpty) ...[
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.straighten, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '二进制位宽：$_bitWidth',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

