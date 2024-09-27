import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: PlayersScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}

class PlayersScreen extends StatefulWidget {
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  bool isLoading = true;
  List<dynamic> players = [];

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    try {
      final response = await http.get(
        Uri.parse('https://v3.football.api-sports.io/players/squads?team=541'),
        headers: {
          'x-apisports-key': '424e6760b2c21954d33bdfd0dbc5477d', 
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('API Response: $jsonResponse'); 
        setState(() {
          players = jsonResponse['response'][0]['players'];
          isLoading = false;
        });
      } else {
        print('Failed to load players, status code: ${response.statusCode}');
        throw Exception('Failed to load players');
      }
    } catch (e) {
      print('Error fetching players: $e');
      throw Exception('Error fetching players');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joueurs'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerDetailScreen(playerId: players[index]['id']),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: players[index]['photo'] != null
                                ? NetworkImage(players[index]['photo']) as ImageProvider
                                : AssetImage('assets/avatar_placeholder.png'),
                            radius: 30,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  players[index]['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  players[index]['position'] ?? 'Position: N/A',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PlayerDetailScreen extends StatefulWidget {
  final int playerId;

  PlayerDetailScreen({required this.playerId});

  @override
  _PlayerDetailScreenState createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  bool isLoading = true;
  dynamic playerDetail;
  List<dynamic> statistics = [];

  @override
  void initState() {
    super.initState();
    fetchPlayerDetail();
  }

  Future<void> fetchPlayerDetail() async {
    try {
      final response = await http.get(
        Uri.parse('https://v3.football.api-sports.io/players?id=${widget.playerId}&season=2021'),
        headers: {
          'x-apisports-key': '424e6760b2c21954d33bdfd0dbc5477d',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Player Detail Response: $jsonResponse');
        setState(() {
          playerDetail = jsonResponse['response'][0]['player'];
          statistics = jsonResponse['response'][0]['statistics'];
          isLoading = false;
        });
      } else {
        print('Failed to load player detail, status code: ${response.statusCode}');
        throw Exception('Failed to load player detail');
      }
    } catch (e) {
      print('Error fetching player detail: $e');
      throw Exception('Error fetching player detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du joueur'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: playerDetail['photo'] != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(playerDetail['photo']),
                                radius: 50,
                              )
                            : Icon(Icons.person, size: 100),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          playerDetail['name'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Position: ${playerDetail['position'] ?? statistics[0]['games']['position']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Nationality: ${playerDetail['nationality']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Date of Birth: ${playerDetail['birth']['date']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Shirt Number: ${statistics[0]['games']['number'] != null ? statistics[0]['games']['number'].toString() : 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Height: ${playerDetail['height']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Weight: ${playerDetail['weight']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Age: ${calculateAge(playerDetail['birth']['date'])}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Statistics:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...statistics.map((stat) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${stat['league']['name']} (${stat['league']['season']})',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text('Appearances: ${stat['games']['appearences']}'),
                                Text('Lineups: ${stat['games']['lineups']}'),
                                Text('Minutes Played: ${stat['games']['minutes']}'),
                                Text('Position: ${stat['games']['position']}'),
                                Text('Rating: ${stat['games']['rating'] ?? 'N/A'}'),
                                Text('Goals: ${stat['goals']['total']}'),
                                Text('Assists: ${stat['goals']['assists'] ?? 'N/A'}'),
                                Text('Saves: ${stat['goals']['saves'] ?? 'N/A'}'),
                                Text('Yellow Cards: ${stat['cards']['yellow']}'),
                                Text('Red Cards: ${stat['cards']['red']}'),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  int calculateAge(String birthDateString) {
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}