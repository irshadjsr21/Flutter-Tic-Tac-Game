import 'package:flutter/material.dart';
import 'dart:math';

import './config.dart';

class GameScreen extends StatefulWidget {
  final bool isDoublePlayer;
  GameScreen(this.isDoublePlayer);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List> _data = [
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
  List<int> _points = [0, 0];
  int _currentUser = 1;

  double _iconSize = 50;
  double _headerIonSize = 70;

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
                  _currentUser == 1 ? Text('Your Turn') : Text(''),
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
                  _currentUser == 2 ? Text('Your Turn') : Text(''),
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
    return ButtonBar(
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
    );
  }

  void _clickedBox(int index1, int index2) {
    if (_data[index1][index2] == 0) {
      setState(() {
        _data[index1][index2] = _currentUser;
        if (_checkWin()) {
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
    });
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
      _points[_currentUser - 1]++;
      _resetBoard();
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

  bool _checkWin() {
    bool flag = false;
    List<int> rdiag = [];
    List<int> ldiag = [];
    for (var i = 0; i < 3; i++) {
      bool rowFlag = true;
      int rowUser = _data[i][0];
      bool colFlag = true;
      int colUser = _data[0][i];

      for (var j = 0; j < 3; j++) {
        if (rowUser != _data[i][j]) rowFlag = false;
        if (colUser != _data[j][i]) colFlag = false;

        if (i == j) {
          ldiag.add(_data[i][j]);
        }

        if (i + j == 2) {
          rdiag.add(_data[i][j]);
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
