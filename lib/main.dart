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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // 明るい黒の背景
      ),
      home: const MyHomePage(title: 'LIFE COUNTER'),
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
    
    // 年齢による条件分岐は変更なし
    if (age < 73) {
      targetDate = DateTime(
        _birthDate!.year + 73,
        _birthDate!.month,
        _birthDate!.day,
      );
    } else if (age < 84) {
      targetDate = DateTime(
        _birthDate!.year + 84,
        _birthDate!.month,
        _birthDate!.day,
      );
    } else {
      setState(() {
        _countdownTime = 'Well done!';
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

  double _calculateProgressToAge73() {
    if (_birthDate == null) return 0.0;
    final now = DateTime.now();
    final age = _calculateAge(_birthDate!, now);
    if (age >= 73) return 1.0;
    final totalDays = DateTime(_birthDate!.year + 73, _birthDate!.month, _birthDate!.day).difference(_birthDate!).inDays;
    final currentDays = now.difference(_birthDate!).inDays;
    return currentDays / totalDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A), // 明るい黒
        elevation: 0, // 影を削除してモダンな見た目に
        centerTitle: true, // タイトルを中央に配置
        title: Text(
          widget.title, 
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300, // 細いフォント
            letterSpacing: 2.0, // 文字間隔を広げる
          )
        ),
      ),
      body: Container(
        color: const Color(0xFF1A1A1A), // 明るい黒の背景
        padding: const EdgeInsets.symmetric(horizontal: 30.0), // 左右の余白を追加
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // 上部の間隔を広げる
              // モダンなボタンデザイン
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2A2A), // ボタン背景をやや明るく
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _birthDate == null 
                    ? 'ENTER YOUR DATE OF BIRTH'
                    : 'DOB: ${_birthDate!.year}/${_birthDate!.month}/${_birthDate!.day}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 40), // 間隔を広げる
              if (_birthDate != null)
                Text(
                  _countdownTime,
                  style: const TextStyle(
                    fontSize: 36, 
                    fontWeight: FontWeight.w300, // より洗練された細いフォント
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              const SizedBox(height: 20),
              if (_birthDate != null)
                Text(
                  'You are only ${_calculateAge(_birthDate!, DateTime.now())} years old !!',
                  style: const TextStyle(
                    fontSize: 20, 
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              const SizedBox(height: 40), // 間隔を広げる
              if (_birthDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LIFE PROGRESS',
                        style: TextStyle(
                          fontSize: 14, 
                          color: Colors.white70,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: LinearProgressIndicator(
                          backgroundColor: const Color(0xFF2A2A2A), // やや明るい黒
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _calculateAge(_birthDate!, DateTime.now()) < 73 
                                ? Colors.amber // 黄色系アクセントカラー
                                : Colors.green
                          ),
                          minHeight: 20,
                          value: _calculateProgressToAge73(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You are life is ${(_calculateProgressToAge73() * 100).toStringAsFixed(2)}% complete',
                        style: const TextStyle(
                          fontSize: 14, 
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(), // 残りのスペースを埋める
              if (_birthDate != null && _calculateAge(_birthDate!, DateTime.now()) >= 73 && _calculateAge(_birthDate!, DateTime.now()) < 84)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40), // 下部の余白を増加
                  child: Text(
                    'Stay healthy from age 73 to 84!',
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w400, 
                      color: Colors.amber, // 黄色系アクセントカラー
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
