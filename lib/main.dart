
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(backgroundColor: Colors.red),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  late List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;

  @override
  void initState() {
    super.initState();
    buttonsList =  doInit();
  }
  List<GameButton> doInit() {
    player1 = [];
    player2 = [];
    activePlayer = 1;

    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if(activePlayer == 1) {
        gb.text = "O";
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      }else {
        gb.text = "X";
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if(winner == -1){
        if(buttonsList.every((p) {
          return p.text !="";
        })){
          showDialog(context: context,
              builder: (_) {
                return CustomDialog("Draw Game", "Please, Press the reset button.", resetGame);
              });
        }else {
          activePlayer == 2?autoPlay():null;
        }
      }
    });
  }

  void autoPlay(){
    var emptyCells = [];
    var list = List.generate(9, (i) {
      return i+1;
    });
    for(var cellID in list){
      if(!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }
    var r = Random();
    var randIndex = r.nextInt(emptyCells.length);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p)=> p.id == cellID);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    var winner = -1;

    if((player1.contains(1) && player1.contains(2) && player1.contains(3)) ||(player1.contains(4) && player1.contains(5) && player1.contains(6))||
        (player1.contains(7) && player1.contains(8) && player1.contains(9))||
        (player1.contains(2) && player1.contains(5) && player1.contains(8))||(player1.contains(3) && player1.contains(6) && player1.contains(9))||
        (player1.contains(1) && player1.contains(5) && player1.contains(9)) || (player1.contains(3) && player1.contains(5) && player1.contains(7)))
    {
      winner = 1;
    }
    else if(player2.contains(1) && player2.contains(2) && player2.contains(3) || (player2.contains(4) && player2.contains(5) && player2.contains(6)) ||
        (player2.contains(7) && player2.contains(8) && player2.contains(9)) || (player2.contains(2) && player2.contains(5) && player2.contains(8)) ||
        (player2.contains(3) && player2.contains(6) && player2.contains(9)) || (player2.contains(1) && player2.contains(5) && player2.contains(9)) ||
        (player2.contains(3) && player2.contains(5) && player2.contains(7)))
    {
      winner = 2;
    }

    if (winner != -1) {
      if(winner == 1) {
        showDialog( context: context,
            builder: (_) {
              return CustomDialog("Player 1 Won","Please, Press the reset button.",resetGame);
            });
      }
      else {
        showDialog(context: context,
            builder: (_) {
              return CustomDialog("Player 2 Won","Please, Press the reset button.",resetGame);
            });
      }
    }
    return winner;
  }

  void resetGame(){
    if(Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("XO Game"),backgroundColor: Colors.deepPurple,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
              ),
              itemCount: buttonsList.length,
              itemBuilder: (context,i) {
                return SizedBox(
                width: 100.0,
                height: 100.0,
                child: RaisedButton(
                  padding: const EdgeInsets.all(20.0),
                  onPressed: buttonsList[i].enabled?() {
                    playGame(buttonsList[i]);
                  }:null,
                  child: Text(
                    buttonsList[i].text,
                    style: const TextStyle(color: Colors.white, fontSize: 50.0,fontWeight: FontWeight.bold ),
                  ),
                  color: buttonsList[i].bg,
                  disabledColor: buttonsList[i].bg,
                ),
              );
              },
            ),
          ),
          RaisedButton(
            child: const Text("Play Now",
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
            color: Colors.deepPurple,
            padding: const EdgeInsets.all(15.0),
            onPressed: resetGame,
          ),
        ],

      ),
    );
  }
}

class GameButton{
  final id;
  String text;
  Color bg;
  bool enabled;


  GameButton({this.id, this.text="",this.bg = Colors.grey, this.enabled = true});
}

class CustomDialog extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  CustomDialog(this.title, this.content, this.callback, [this.actionText = "Reset"]);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(onPressed: callback,color: Colors.white,child: Text(actionText)),
      ],
    );
  }
}