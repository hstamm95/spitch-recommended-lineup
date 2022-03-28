import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/player.dart';

void main() {
  runApp(const Spitch());
}

class Spitch extends StatelessWidget {
  const Spitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'SPITCH',
      theme: CupertinoThemeData(
        primaryColor: Color(0xFF33BA49),
      ),
      home: RecommendedLineup(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecommendedLineup extends StatefulWidget {
  const RecommendedLineup({Key? key}) : super(key: key);

  @override
  State<RecommendedLineup> createState() => _RecommendedLineupState();
}

class _RecommendedLineupState extends State<RecommendedLineup> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Lineup'),
          ),
        ],
        body: Center(
          child: FutureBuilder<List<Player>>(
            future: fetchPlayers(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                return PlayerList(players: snapshot.data!);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

List<Player> parsePlayers(String responseBody) {
  Map<String, dynamic> playerMap = jsonDecode(responseBody);
  final parsed = playerMap['players'].cast<Map<String, dynamic>>();

  return parsed.map<Player>((json) => Player.fromJson(json)).toList();
}

Future<List<Player>> fetchPlayers(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://api.spitch.live/contestants?competition_id=6by3h89i2eykc341oz7lv1ddd'));

  return compute(parsePlayers, response.body);
}

class PlayerList extends StatelessWidget {
  const PlayerList({Key? key, required this.players}) : super(key: key);

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    List<Player>? goalkeepers = [];
    List<Player>? defender = [];
    List<Player>? midfielder = [];
    List<Player>? attacker = [];

    for (var i = 0; i < players.length; i++) {
      if (players[i].active && !players[i].injured) {
        switch (players[i].position) {
          case 'goalkeeper':
            goalkeepers.insert(0, players[i]);
            break;
          case 'defender':
            defender.insert(0, players[i]);
            break;
          case 'midfielder':
            midfielder.insert(0, players[i]);
            break;
          case 'attacker':
            attacker.insert(0, players[i]);
            break;
        }
      }
    }

    players.sort(((a, b) => b.avgScore.compareTo(a.avgScore)));
    goalkeepers.sort(((a, b) => b.avgScore.compareTo(a.avgScore)));
    defender.sort(((a, b) => b.avgScore.compareTo(a.avgScore)));
    midfielder.sort(((a, b) => b.avgScore.compareTo(a.avgScore)));
    attacker.sort(((a, b) => b.avgScore.compareTo(a.avgScore)));

    List<Player> lineup = [
      goalkeepers[0],
      defender[0],
      defender[1],
      defender[2],
      midfielder[0],
      midfielder[1],
      midfielder[2],
      midfielder[3],
      attacker[0],
      attacker[1],
      attacker[2],
    ];

    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
              color: Colors.black26,
            ),
        itemCount: lineup.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 40,
            color: const Color(0x00000000),
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                players[0].id == lineup[index].id
                    ? Text(
                        '${lineup[index].firstName} ${lineup[index].lastName} ©')
                    : Text(
                        '${lineup[index].firstName} ${lineup[index].lastName}'),
                Text(lineup[index].avgScore.toString()),
              ],
            ),
          );
        });
  }
}
