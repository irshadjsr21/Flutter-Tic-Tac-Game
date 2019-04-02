import 'package:flutter/material.dart';

import './game.dart';

class GameTypeSelect extends StatelessWidget {
  final TextStyle _headingStyle = new TextStyle(
    color: Colors.white,
    fontSize: 50,
  );

  final _textStyle = new TextStyle(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  'Tic Tac Game',
                  style: _headingStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: RaisedButton(
                      color: Colors.white,
                      splashColor: Colors.grey[200],
                      highlightColor: Colors.grey[200],
                      child: Text('Single Player'),
                      onPressed: () {
                        _navigateToGame(false, context);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: Colors.grey[200],
                    highlightColor: Colors.grey[200],
                    child: Text('Double Player'),
                    onPressed: () {
                      _navigateToGame(true, context);
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Made with',
                    style: _textStyle,
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  Text(
                    ' by Irshad',
                    style: _textStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToGame(bool isDoublePlayer, BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => GameScreen(isDoublePlayer)));
  }
}
