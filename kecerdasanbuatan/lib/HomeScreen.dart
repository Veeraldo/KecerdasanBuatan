import 'package:flutter/material.dart';
import 'package:kecerdasanbuatan/services/THT_service.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final THTServices _thtServices = THTServices();

  Map<String, String> _allGejala = {};
  List<String> _listGejala = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosa Penyakit'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
