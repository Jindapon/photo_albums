import 'dart:convert';

import "package:dio/dio.dart";
import 'package:flutter/material.dart';
import 'package:photo_albums/models/albums_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<Album>? _itemList;
  String? _error;

  Future<void> getTodos() async {
    try {
      setState(() {
        _error = null;
      });

      await Future.delayed(const Duration(seconds: 3), () {});

      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.toString());

      final List<dynamic> list = jsonDecode(response.data.toString());
      final List<Album> albumList =
          list.map((item) => Album.fromJson(item)).toList();

      setState(() {
        _itemList = albumList;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Albums'),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    Widget body;
    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                getTodos();
              },
              child: const Text('RETRY')),
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
        itemCount: _itemList!.length,
        itemBuilder: (context, index) {
          var album = _itemList![index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${album.title} ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    // ใช้ Row แทน Column
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.lightBlueAccent,
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "Album ID: ${album.id}",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.pinkAccent,
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "User ID: ${album.userId}",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return body;
  }
}
