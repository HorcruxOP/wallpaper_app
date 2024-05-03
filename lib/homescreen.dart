import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/fullscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          "Authorization":
              "kTC8ZLBvOvs5Uos87draaNZe6Nr7umFlxP7Rm5skkIiAPBRfAgUFmare"
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result["photos"];
      });
      
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        "https://api.pexels.com/v1/curated?per_page=80&page$page";
    await http.get(Uri.parse(url), headers: {
      "Authorization":
          "kTC8ZLBvOvs5Uos87draaNZe6Nr7umFlxP7Rm5skkIiAPBRfAgUFmare"
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result["photos"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FullScreen(
                                imageUrl: images[index]["src"]["large2x"]);
                          },
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Image.network(
                        images[index]["src"]["tiny"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              )),
          InkWell(
            onTap: () => loadMore(),
            child: Container(
              color: Colors.black,
              height: 60,
              width: double.infinity,
              child: const Center(
                child: Text(
                  "Load More",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
