import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProjectMap(),
  ));
}

class ProjectMap extends StatefulWidget {
  @override
  State<ProjectMap> createState() => _ProjectMapState();
}

class _ProjectMapState extends State<ProjectMap> {
  LatLng point = LatLng(6.2884850308115015, -75.55941169689001); //initial coordinates
  TextEditingController ctrl = TextEditingController();
  List<Marker> mark = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrl.text = "latitude: ${point.latitude}\nlongitude: ${point.longitude}";
    makeMarker();
  }

  Future<void> makeMarker() async {
    mark.add(
      Marker(
        width: 50.0,
        height: 50.0,
        point: point, 
        builder: (ctx) {
          return const Icon(
            Icons.location_on,
            color: Colors.green,
          );
        }
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
        color: Colors.transparent,
        child: Text('bottom screen widget'),
        elevation: 20.0,
      ),
      body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          FlutterMap(
          options: MapOptions(
            center: point,
            zoom: 15.0,
            onTap: (coord) async {
              ctrl.text = "latitude: ${coord.latitude}\nlongitude: ${coord.longitude}";
              point = coord;
              await makeMarker();
              setState(() { });
            }
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:"https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayerOptions(
              markers: mark,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Card(
            color: Colors.white,
            child: TextFormField(
              enabled: false,
              controller: ctrl,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.location_on, color: Colors.green,),
                contentPadding: const EdgeInsets.only(left: 10.0, top: 5.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, bottom: 8.0),
            child: SizedBox(
              height: 70.0,
              width: 100.0,
              child: ElevatedButton(
                onPressed: () async {
                  mark = [];
                  ctrl.text = "";
                  setState(() {});
                }, 
                child: const Text("Clear\nmarker"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black38
                ),
              ),
            ),
          ),
        ),
      ],
      ),
    ));
  }
}
