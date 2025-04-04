import 'package:flutter/material.dart';
import 'dart:async'; // タイマー用

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MyHomePage(title: 'Life Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentTime = '';
  String _countdownTime = '';
  DateTime? _birthDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // 初期表示時に時間をセット
    _updateTime();
    // 1秒ごとに時間を更新
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
      if (_birthDate != null) {
        _updateCountdown();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // ウィジェットが破棄されるときにタイマーを停止
    super.dispose();
  }

  // 現在時刻を更新するメソッド
  void _updateTime() {
    final now = DateTime.now();
    final timeString = 
        '${now.year}年${now.month.toString().padLeft(2, '0')}月${now.day.toString().padLeft(2, '0')}日 '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    
    setState(() {
      _currentTime = timeString;
    });
  }

  // 年齢を計算するメソッド
  int _calculateAge(DateTime birthDate, DateTime currentDate) {
    var age = currentDate.year - birthDate.year;
    
    // 誕生日がまだ来ていない場合は1引く
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  // カウントダウンを更新するメソッド
  void _updateCountdown() {
    if (_birthDate == null) return;
    
    final now = DateTime.now(); // 毎回最新の時間を取得
    final age = _calculateAge(_birthDate!, now);
    
    DateTime targetDate;
    String targetMessage;
    
    // 年齢による条件分岐は変更なし
    if (age < 73) {
      targetDate = DateTime(
        _birthDate!.year + 73,
        _birthDate!.month,
        _birthDate!.day,
      );
      targetMessage = '73歳まであと';
    } else if (age < 84) {
      targetDate = DateTime(
        _birthDate!.year + 84,
        _birthDate!.month,
        _birthDate!.day,
      );
      targetMessage = '84歳まであと';
    } else {
      setState(() {
        _countdownTime = '目標年齢（84歳）を超えています';
      });
      return;
    }
    
    // 以下の部分は変更なし
    if (targetDate.isBefore(now)) {
      if (age < 73) {
        targetDate = DateTime(
          _birthDate!.year + 74,
          _birthDate!.month,
          _birthDate!.day,
        );
      } else {
        targetDate = DateTime(
          _birthDate!.year + 85,
          _birthDate!.month,
          _birthDate!.day,
        );
      }
    }
    
    // 残り時間を計算（毎秒新しい値になる）
    final remaining = targetDate.difference(now);
    
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    
    // UIを更新
    if (mounted) {  // Widgetがまだ有効かチェック
      setState(() {
        _countdownTime = '$days days ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    }
  }

  // 日付選択ダイアログを表示するメソッド
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1980),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: '生年月日を選択してください',
      cancelText: 'キャンセル',
      confirmText: '決定',
    );
    
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
      _updateCountdown(); // 日付が選択されたらすぐにカウントダウンを更新
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // 間隔を追加
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _birthDate == null 
                    ? 'Enter your BOD'
                    : 'DOB: ${_birthDate!.year}/${_birthDate!.month}/${_birthDate!.day}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (_birthDate != null)
                Text(
                  _countdownTime,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              if (_birthDate != null)
                Text(
                  'You’re only ${_calculateAge(_birthDate!, DateTime.now())} years old !!',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              const Spacer(), // 残りのスペースを埋める
              if (_birthDate != null && _calculateAge(_birthDate!, DateTime.now()) >= 73 && _calculateAge(_birthDate!, DateTime.now()) < 84)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    '73歳から84歳までの貴重な時間です',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
