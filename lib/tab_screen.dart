import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Menu Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabScreen(),
    );
  }
}

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tab Menu'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Welcome'),
              Tab(icon: Icon(Icons.landscape), text: 'Pariwisata'),
              Tab(icon: Icon(Icons.health_and_safety), text: 'Kesehatan'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WelcomeTab(),
            PariwisataTab(),
            KesehatanTab(),
            ProfileTab(),
          ],
        ),
      ),
    );
  }
}

class WelcomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the App!', style: TextStyle(fontSize: 24)),
    );
  }
}

class PariwisataTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Pariwisata (Tourism) information goes here', style: TextStyle(fontSize: 18)),
    );
  }
}

class KesehatanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Kesehatan (Health) information goes here', style: TextStyle(fontSize: 18)),
    );
  }
}

class ProfileTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.firstName),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}

class User {
  final String firstName;
  final String email;
  User({required this.firstName, required this.email});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}