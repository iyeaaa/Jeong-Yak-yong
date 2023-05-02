import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final double fem;

  const SearchBar(this.fem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20 * fem),
      width: 220 * fem,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: const Center(
        child: TextField(
          style: TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search..',
            hintStyle: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  final double fem;

  const SearchButton(this.fem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(27 * fem, 20 * fem, 27 * fem, 20 * fem),
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff8a60ff),
        borderRadius: BorderRadius.circular(20 * fem),
      ),
      child: Image.asset(
        'image/fe-search-kxN.png',
        width: 20 * fem,
        height: 20 * fem,
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final double fem;

  const SearchWidget(this.fem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20 * fem, 0, 0),
      child: SizedBox(
        width: double.infinity,
        height: 72 * fem,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchBar(fem),
            SearchButton(fem),
          ],
        ),
      ),
    );
  }
}
