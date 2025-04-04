import 'package:flutter/material.dart';
import 'dart:async'; // タイマー用

// StatelessWidgetからStatefulWidgetに変更
class NextPage extends StatefulWidget {
  const NextPage({super.key, required this.text});

  final String text;

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
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
    
    final now = DateTime.now();
    final age = _calculateAge(_birthDate!, now);
    
    DateTime targetDate;
    String targetMessage;
    
    if (age < 73) {
      // 73歳の誕生日を計算
      targetDate = DateTime(
        _birthDate!.year + 73,
        _birthDate!.month,
        _birthDate!.day,
      );
      targetMessage = '73歳まであと';
    } else if (age < 84) {
      // 84歳の誕生日を計算
      targetDate = DateTime(
        _birthDate!.year + 84,
        _birthDate!.month,
        _birthDate!.day,
      );
      targetMessage = '84歳まであと';
    } else {
      // 84歳を超えている場合
      setState(() {
        _countdownTime = '目標年齢（84歳）を超えています';
      });
      return;
    }
    
    // 目標日までの残り時間を計算
    final difference = targetDate.difference(now);
    
    // 残り時間が負の場合（その年の誕生日が過ぎている場合）
    if (difference.isNegative) {
      if (age < 73) {
        targetDate = DateTime(
          _birthDate!.year + 73,
          _birthDate!.month,
          _birthDate!.day,
        );
        targetMessage = '73歳まであと';
      } else {
        targetDate = DateTime(
          _birthDate!.year + 84,
          _birthDate!.month,
          _birthDate!.day,
        );
        targetMessage = '84歳まであと';
      }
    }
    
    // 残り時間を再計算
    final remaining = targetDate.difference(now);
    
    // 日、時間、分、秒に変換
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    
    // カウントダウン文字列を更新
    setState(() {
      _countdownTime = '$targetMessage $days日 ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
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
      appBar: AppBar(),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.text, style: const TextStyle(fontSize: 100, color: Colors.white)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('戻る'),
              ),
              const SizedBox(height: 20), // 間隔を追加
              Text(
                '現在時刻: $_currentTime',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _birthDate == null 
                    ? '生年月日を選択してください'
                    : '生年月日: ${_birthDate!.year}年${_birthDate!.month}月${_birthDate!.day}日',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (_birthDate != null)
                Text(
                  _countdownTime,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              if (_birthDate != null)
                Text(
                  '現在の年齢: ${_calculateAge(_birthDate!, DateTime.now())}歳',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
