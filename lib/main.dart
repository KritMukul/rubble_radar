import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Worker Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (mounted) {
      setState(() {
        _isLoggedIn = username != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? const DashboardScreen() : const LoginPage();
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Worker> _workers = [
    Worker(
        id: 1,
        gender: Gender.male,
        name: "TX 1",
        latitude: 34.7749,
        longitude: -119.4194,
        details: "Works at Site A",
        bodyTemp: 98.6,
        heartRate: 72,
        address: "JFLKDSJ",
        age: 27,
        phoneNumber: "83249823"),
    Worker(
        id: 2,
        gender: Gender.female,
        name: "TX 2",
        latitude: 34.7522,
        longitude: -119.2437,
        details: "Works at Site B",
        bodyTemp: 99.1,
        heartRate: 75,
        address: "JFDSKLJF",
        age: 34,
        phoneNumber: "83249823"),
    Worker(
        id: 3,
        gender: Gender.other,
        name: "TX 3",
        latitude: 34.7628,
        longitude: -119.3060,
        details: "Works at Site C",
        bodyTemp: 97.8,
        heartRate: 68,
        address: "DSIUFOIDS",
        age: 29,
        phoneNumber: "83249823"),
  ];

  List<Worker> _filteredWorkers = [];
  String _mapView = "Normal";

  @override
  void initState() {
    super.initState();
    _filteredWorkers = _workers;
    _searchController.addListener(_filterWorkers);
  }

  void _filterWorkers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWorkers = _workers
          .where((worker) =>
              worker.name.toLowerCase().contains(query) ||
              worker.details.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleMapView() {
    setState(() {
      _mapView = _mapView == "Normal" ? "Satellite" : "Normal";
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _showRegisterWorkerModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();
    final TextEditingController bodyTempController = TextEditingController();
    final TextEditingController heartRateController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

    Gender selectedGender = Gender.male;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 13, 27, 42),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Register New Worker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                  labelText: 'Worker Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: detailsController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                  labelText: 'Details',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bodyTempController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                  labelText: 'Body Temperature (°F)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: heartRateController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                  labelText: 'Heart Rate (BPM)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneNumberController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelStyle:
                      TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  DropdownButton<Gender>(
                    value: selectedGender,
                    style: const TextStyle(color: Colors.white),
                    items: Gender.values.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(
                          gender.toString().split('.').last,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                    dropdownColor: const Color.fromARGB(255, 13, 27, 42),
                    iconEnabledColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 44, 165, 141)),
                onPressed: () {
                  final newWorker = Worker(
                    id: _workers.length + 1,
                    name: nameController.text.trim(),
                    details: detailsController.text.trim(),
                    latitude: 34.7628, // Default latitude
                    longitude: -119.3060, // Default longitude
                    bodyTemp: double.tryParse(bodyTempController.text) ?? 98.6,
                    heartRate: int.tryParse(heartRateController.text) ?? 72,
                    gender: selectedGender,
                    address: addressController.text.trim(),
                    phoneNumber: phoneNumberController.text.trim(),
                    age: int.tryParse(ageController.text) ?? 30,
                  );
                  setState(() {
                    _workers.add(newWorker);
                    _filteredWorkers = _workers;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Register Worker',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rubble Radar Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color.fromARGB(255, 13, 27, 42),
        actions: [
          IconButton(
            icon: Icon(
              _mapView == "Normal" ? Icons.satellite : Icons.map,
              color: Colors.white,
            ),
            onPressed: _toggleMapView,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 13, 27, 42),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search Workers...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: FlutterMapWidget(
                  workers: _filteredWorkers, mapView: _mapView),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Worker on Duty (${_filteredWorkers.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredWorkers.length,
                itemBuilder: (context, index) {
                  final worker = _filteredWorkers[index];
                  return Card(
                    color: const Color.fromARGB(255, 27, 38, 59),
                    margin: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                    child: ListTile(
                      title: Text(
                        worker.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker.details,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.thermostat,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${worker.bodyTemp}°F',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${worker.heartRate} BPM',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          Text(
                            '${worker.latitude.toStringAsFixed(2)}, ${worker.longitude.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 120, 90),
        tooltip: 'Add a Worker',
        onPressed: _showRegisterWorkerModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlutterMapWidget extends StatelessWidget {
  final List<Worker> workers;
  final String mapView;

  const FlutterMapWidget(
      {super.key, required this.workers, required this.mapView});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(),
      children: [
        TileLayer(
          urlTemplate: mapView == "Normal"
              ? "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
              : "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: workers.map((worker) {
            return Marker(
              point: LatLng(worker.latitude, worker.longitude),
              width: 50.0,
              height: 50.0,
              child: const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 214, 34, 70),
                size: 40.0,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

enum Gender { male, female, other }

class Worker {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String details;
  final double bodyTemp;
  final int heartRate;
  final Gender gender;
  final String address;
  final String phoneNumber;
  final int age;

  Worker({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.details,
    required this.bodyTemp,
    required this.heartRate,
    required this.gender,
    required this.address,
    required this.phoneNumber,
    required this.age,
  });
}
