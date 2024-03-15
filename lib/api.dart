import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homework_api/beers.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List<Beer>? _beers;
  List<Beer>? _filteredBeers;
  final TextEditingController _searchController = TextEditingController();

  void _getBeers() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response = await dio.get('https://api.sampleapis.com/beers/ale');

    List list = jsonDecode(response.data);

    setState(() {
      _beers = list.map((beerJson) => Beer.fromJson(beerJson)).toList();
      _filteredBeers = _beers;
      _beers!.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _filterBeers(String searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredBeers = _beers;
      });
    } else {
      setState(() {
        _filteredBeers = _beers
            ?.where((beer) =>
                beer.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getBeers();
    _searchController.addListener(() {
      _filterBeers(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beer List',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.pink,
        
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredBeers == null
                ? const SizedBox.shrink()
                : ListView.builder(
                    itemCount: _filteredBeers!.length,
                    itemBuilder: (context, index) {
                      var beer = _filteredBeers![index];
                      return ListTile(
                        title: Text(beer.name),
                        subtitle: Text('Price: ${beer.price}'),
                        trailing: beer.image.isNotEmpty
                            ? Image.network(
                                beer.image,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Icon(Icons.error));
                                },
                              )
                            : const SizedBox(width: 50, height: 50),
                        onTap: () {
                          _showMyDialog(
                            beer.name,
                            beer.price,
                            beer.averageRating,
                            beer.reviews,
                            beer.image,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(String name, String price, double averageRating,
    int reviews, String image) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(name),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Price: $price'),
              Text('Average Rating: $averageRating'),
              Text('Reviews: $reviews'),
              image.isNotEmpty
                  ? Image.network(
                      image,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Image not available');
                      },
                    )
                  : const Text('No image available'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CLOSE'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
