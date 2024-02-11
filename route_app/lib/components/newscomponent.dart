import 'package:flutter/material.dart';

Widget newsComponent(context, article, callback) {
  return Stack(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            image: article['urlToImage'] == null
                ? null
                : DecorationImage(
                    image: NetworkImage(article['urlToImage']),
                    fit: BoxFit.cover),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 0))
            ]),
      ),
      GestureDetector(
        onTap: callback,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  colors: [
                    Colors.black12.withOpacity(0.0),
                    Colors.black,
                  ],
                  begin: FractionalOffset.center,
                  end: FractionalOffset.bottomCenter),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 0))
              ]),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(30),
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Text(
            article["title"],
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: AlignmentDirectional.topEnd,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: const Icon(
              Icons.link,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    ],
  );
}
