import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import './config.dart';

class GameScreen extends StatefulWidget {
  final bool isDoublePlayer;
  final int selectedPlayer;
  GameScreen(this.isDoublePlayer, this.selectedPlayer);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List> _data;
  List<int> _points;
  int _currentUser;
  bool _dontListenClick;

  double _iconSize = 50;
  double _headerIonSize = 70;

  int _computerIcon;
  var _timer1;
  var _timer2;

  @override
  void initState() {
    _resetGame();
    super.initState();
  }

  @override
  void deactivate() {
    if (_timer1 != null && _timer1.isActive) {
      _timer1.cancel();
    }

    if (_timer2 != null && _timer2.isActive) {
      _timer2.cancel();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Game'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            _buildHeader(),
            _buildGame(),
            _buildActions(),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: _currentUser == 1
                  ? BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(1, 1),
                            spreadRadius: 1),
                      ],
                    )
                  : null,
              child: Column(
                children: <Widget>[
                  _currentUser == 1 && _computerIcon == 1
                      ? Text('Computer\'s Turn')
                      : _currentUser == 1 ? Text('Your Turn') : Text(''),
                  Icon(
                    Config.icons['cross'],
                    size: _headerIonSize,
                  ),
                  Text(_points[0].toString())
                ],
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: _currentUser == 2
                  ? BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(1, 1),
                            spreadRadius: 1),
                      ],
                    )
                  : null,
              child: Column(
                children: <Widget>[
                  _currentUser == 2 && _computerIcon == 2
                      ? Text('Computer\'s Turn')
                      : _currentUser == 2 ? Text('Your Turn') : Text(''),
                  Icon(
                    Config.icons['circle'],
                    size: _headerIonSize,
                  ),
                  Text(_points[1].toString())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGame() {
    List<Widget> game = [];
    for (var i = 0; i < 3; i++) {
      game.add(_buildGameColumn(i));
    }

    return Column(
      children: game.toList(),
    );
  }

  Widget _buildGameColumn(int index) {
    List<int> elems = [0, 1, 2];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: elems.map((elem) => _buildGameBox(index, elem)).toList(),
    );
  }

  Widget _buildGameBox(int index1, int index2) {
    return Container(
      decoration: BoxDecoration(border: _getBorder(index1, index2)),
      width: 100,
      height: 100,
      child: Material(
        child: InkWell(
          highlightColor: Colors.black,
          splashColor: Colors.black,
          onTap: () {
            _clickedBox(index1, index2);
          },
          child: Center(
              child: _data[index1][index2] == 1
                  ? Icon(
                      Config.icons['cross'],
                      size: _iconSize,
                    )
                  : _data[index1][index2] == 2
                      ? Icon(Config.icons['circle'], size: _iconSize)
                      : null),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            color: Colors.blue,
            highlightColor: Colors.blueAccent,
            minWidth: 100,
            height: 45,
            child: Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _resetGame();
            },
          )
        ],
      ),
    );
  }

  void _clickedBox(int index1, int index2) {
    if (_dontListenClick == null || _dontListenClick) {
      return;
    }

    if (_data[index1][index2] == 0) {
      setState(() {
        _data[index1][index2] = _currentUser;
        if (_checkWin(_data)) {
          _handlePlayerWin();
        } else if (_checkFilled()) {
          _resetBoard();
        } else {
          _switchUser();
        }
      });
    }
  }

  void _switchUser() {
    _currentUser = _currentUser == 1 ? 2 : 1;
    if (!widget.isDoublePlayer && _currentUser == _computerIcon) {
      _computerTurn();
    }
  }

  void _resetBoard() {
    var randomGenerator = new Random();
    setState(() {
      _data = [
        [
          0,
          0,
          0,
        ],
        [
          0,
          0,
          0,
        ],
        [
          0,
          0,
          0,
        ],
      ];
      _currentUser = randomGenerator.nextInt(2) + 1;
      _dontListenClick = false;
      _computerIcon = widget.selectedPlayer == 1 ? 2 : 1;
    });
    if (!widget.isDoublePlayer && _currentUser == _computerIcon) {
      _computerTurn();
    }
  }

  void _resetPoints() {
    setState(() {
      _points = [0, 0];
    });
  }

  void _resetGame() {
    _resetBoard();
    _resetPoints();
  }

  void _handlePlayerWin() {
    setState(() {
      _dontListenClick = true;
    });
    _timer1 = new Timer(new Duration(milliseconds: 500), () {
      setState(() {
        _points[_currentUser - 1]++;
        _resetBoard();
        _dontListenClick = false;
      });
    });
  }

  bool _checkFilled() {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (_data[i][j] == 0) return false;
      }
    }

    return true;
  }

  bool _checkWin(List _newData) {
    bool flag = false;
    List<int> rdiag = [];
    List<int> ldiag = [];
    for (var i = 0; i < 3; i++) {
      bool rowFlag = true;
      int rowUser = _newData[i][0];
      bool colFlag = true;
      int colUser = _newData[0][i];

      for (var j = 0; j < 3; j++) {
        if (rowUser != _newData[i][j]) rowFlag = false;
        if (colUser != _newData[j][i]) colFlag = false;

        if (i == j) {
          ldiag.add(_newData[i][j]);
        }

        if (i + j == 2) {
          rdiag.add(_newData[i][j]);
        }
      }

      if (rowFlag || colFlag) {
        if (rowFlag && rowUser == 0) continue;
        if (colFlag && colUser == 0) continue;
        flag = true;
        break;
      }
    }

    if (!flag) {
      int middle = ldiag[1];
      bool lDiagFlag = true;
      bool rDiagFlag = true;
      for (var i = 0; i < ldiag.length; i++) {
        if (middle != ldiag[i]) lDiagFlag = false;
        if (middle != rdiag[i]) rDiagFlag = false;
      }

      if ((lDiagFlag || rDiagFlag) && middle != 0) {
        flag = true;
      }
    }

    return flag;
  }

  void _computerTurn() {
    List<List<int>> possibleMoves = [];
    bool flag = false;
    setState(() {
      _dontListenClick = true;
    });

    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (_data[i][j] == 0) {
          List _newData = _cloneData();
          _newData[i][j] = _computerIcon;
          possibleMoves.add([i, j]);
          if (_checkWin(_newData)) {
            _playComputerTurn(i, j);
            flag = true;
            break;
          }
        }
      }
    }

    if (!flag) {
      var randomGenerator = new Random();
      int index = randomGenerator.nextInt(possibleMoves.length);
      setState(() {
        _playComputerTurn(possibleMoves[index][0], possibleMoves[index][1]);
      });
    }
  }

  void _playComputerTurn(int index1, int index2) {
    _timer2 = new Timer(new Duration(milliseconds: 500), () {
      setState(() {
        _data[index1][index2] = _computerIcon;
        _dontListenClick = false;
      });
      if (_checkWin(_data)) {
        _handlePlayerWin();
      } else if (_checkFilled()) {
        _resetBoard();
      } else {
        _switchUser();
      }
    });
  }

  List _cloneData() {
    List<List> _newData = [
      [
        0,
        0,
        0,
      ],
      [
        0,
        0,
        0,
      ],
      [
        0,
        0,
        0,
      ],
    ];

    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        _newData[i][j] = _data[i][j];
      }
    }

    return _newData;
  }

  BoxBorder _getBorder(int index1, int index2) {
    BorderSide borderStyle = BorderSide(width: 1, color: Colors.black);
    BorderSide noBorderStyle = BorderSide(width: 1, color: Colors.transparent);
    Map<String, BorderSide> border = {
      't': borderStyle,
      'b': borderStyle,
      'r': borderStyle,
      'l': borderStyle,
    };

    if (index1 == 0) {
      border['t'] = noBorderStyle;
    }

    if (index1 == 2) {
      border['b'] = noBorderStyle;
    }

    if (index2 == 0) {
      border['l'] = noBorderStyle;
    }

    if (index2 == 2) {
      border['r'] = noBorderStyle;
    }

    return Border(
        top: border['t'],
        bottom: border['b'],
        left: border['l'],
        right: border['r']);
  }
}
