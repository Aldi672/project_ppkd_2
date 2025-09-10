import 'package:flutter/material.dart';
import 'package:project_2/app_crud/pages/Api/authentication.dart';
import 'package:project_2/app_crud/models/get_lapangan.dart';
import 'package:project_2/app_crud/pages/detail_login/pages_tambahan/card_rp.dart';

class SavedFieldsPage extends StatefulWidget {
  static const String routeName = '/saved-fields';

  const SavedFieldsPage({super.key});

  @override
  State<SavedFieldsPage> createState() => _SavedFieldsPageState();
}

class _SavedFieldsPageState extends State<SavedFieldsPage> {
  late Future<SportCard> _savedFieldsFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedFields();
  }

  Future<void> _loadSavedFields() async {
    setState(() {
      _savedFieldsFuture = AuthenticationAPI.getFields();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapangan Tersimpan'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<SportCard>(
              future: _savedFieldsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada lapangan tersimpan'),
                  );
                } else {
                  final fields = snapshot.data!.data;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      final field = fields[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Image.network(
                            field.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(field.name),
                          subtitle: Text(
                            "${formatRupiah(field.pricePerHour)}/jam",
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.bookmark_remove,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Implement remove from saved
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
