import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/database/db.dart';

class MyAdoptionsScreen extends StatefulWidget {
  const MyAdoptionsScreen({super.key});

  @override
  State<MyAdoptionsScreen> createState() => _MyAdoptionsScreenState();
}

class _MyAdoptionsScreenState extends State<MyAdoptionsScreen> {
  List<Map<String, dynamic>> detailedAdoptions = [];
  List<Map<String, dynamic>> simpleAdoptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllAdoptions();
  }

  Future<void> loadAllAdoptions() async {
    setState(() => isLoading = true);

    final detailed = await DBHelper.getAdoptions();
    final simple = await DBHelper.getSimpleAdoptions();

    setState(() {
      detailedAdoptions = detailed;
      simpleAdoptions = simple;
      isLoading = false;
    });
  }

  Future<void> _deleteDetailedAdoption(int id, String petName) async {
    final confirmed = await _showDeleteConfirmation(petName);
    if (confirmed) {
      await DBHelper.deleteAdoption(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Adoption of $petName cancelled'),
          backgroundColor: Colors.red,
        ),
      );
      loadAllAdoptions();
    }
  }

  Future<void> _deleteSimpleAdoption(int id, String name) async {
    final confirmed = await _showDeleteConfirmation("adoption by $name");
    if (confirmed) {
      await DBHelper.deleteSimpleAdoption(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Adoption by $name cancelled'),
          backgroundColor: Colors.red,
        ),
      );
      loadAllAdoptions();
    }
  }

  Future<bool> _showDeleteConfirmation(String itemName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cancel Adoption?'),
            content: Text(
              'Are you sure you want to cancel this adoption?\n\n$itemName',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Yes, Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showAdoptionDetails(Map<String, dynamic> adoption, bool isDetailed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.pets, color: Colors.orange),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isDetailed
                    ? adoption['petName'] ?? 'Unknown Pet'
                    : 'Adoption Details',
                style: GoogleFonts.cabin(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isDetailed
                ? [
                    _buildDetailRow('Pet Name', adoption['petName']),
                    _buildDetailRow('Owner', adoption['ownerName']),
                    const Divider(),
                    _buildDetailRow('Adopter Name', adoption['adopterName']),
                    _buildDetailRow('Phone', adoption['phone']),
                    _buildDetailRow('Address', adoption['address']),
                    _buildDetailRow('Reason', adoption['reason'] ?? 'N/A'),
                    _buildDetailRow(
                      'Adoption Date',
                      adoption['adoptionDate']?.substring(0, 10),
                    ),
                  ]
                : [
                    _buildDetailRow('Name', adoption['name']),
                    _buildDetailRow('Age', adoption['age']?.toString()),
                    _buildDetailRow('Gender', adoption['gender']),
                    _buildDetailRow(
                      'Pet Count',
                      adoption['petCount']?.toString(),
                    ),
                    _buildDetailRow(
                      'Pets Selected',
                      adoption['petName'] ?? 'None',
                    ),
                  ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.cabin(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? 'N/A', style: GoogleFonts.cabin(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAdoptions = detailedAdoptions.length + simpleAdoptions.length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 234, 207),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 234, 207),
        title: Text(
          'My Adoptions ($totalAdoptions)',
          style: GoogleFonts.cabin(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadAllAdoptions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : totalAdoptions == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    'No adoptions yet',
                    style: GoogleFonts.cabin(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Start adopting pets from the Adopt tab!',
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadAllAdoptions,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  if (detailedAdoptions.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '📋 Detailed Adoptions (${detailedAdoptions.length})',
                        style: GoogleFonts.cabin(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...detailedAdoptions.map((adoption) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: InkWell(
                          onTap: () => _showAdoptionDetails(adoption, true),
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      adoption['petImage'] != null &&
                                          adoption['petImage'] != ''
                                      ? Image.network(
                                          adoption['petImage'],
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                width: 70,
                                                height: 70,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.pets,
                                                  size: 40,
                                                ),
                                              ),
                                        )
                                      : Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.orange[100],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.pets,
                                            size: 40,
                                            color: Colors.orange,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 15),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        adoption['petName'] ?? 'Unknown Pet',
                                        style: GoogleFonts.cabin(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Adopter: ${adoption['adopterName'] ?? 'Unknown'}',
                                        style: GoogleFonts.cabin(fontSize: 14),
                                      ),
                                      if (adoption['phone'] != null)
                                        Text(
                                          'Phone: ${adoption['phone']}',
                                          style: GoogleFonts.cabin(
                                            fontSize: 12,
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '📅 ${adoption['adoptionDate']?.substring(0, 10) ?? 'N/A'}',
                                        style: GoogleFonts.cabin(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    const SizedBox(height: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deleteDetailedAdoption(
                                        adoption['id'],
                                        adoption['petName'] ?? 'Unknown Pet',
                                      ),
                                      tooltip: 'Cancel Adoption',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],

                  if (simpleAdoptions.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '⚡ Quick Adoptions (${simpleAdoptions.length})',
                        style: GoogleFonts.cabin(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...simpleAdoptions.map((adoption) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        color: Colors.amber[50],
                        child: InkWell(
                          onTap: () => _showAdoptionDetails(adoption, false),
                          borderRadius: BorderRadius.circular(15),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange[200],
                              child: const Icon(
                                Icons.pets,
                                color: Colors.orange,
                              ),
                            ),
                            title: Text(
                              adoption['name'] ?? 'Unknown',
                              style: GoogleFonts.cabin(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Age: ${adoption['age']} | Gender: ${adoption['gender']}',
                                  style: GoogleFonts.cabin(fontSize: 12),
                                ),
                                if (adoption['petName'] != null &&
                                    adoption['petName'] != '')
                                  Text(
                                    'Pets: ${adoption['petName']}',
                                    style: GoogleFonts.cabin(
                                      fontSize: 11,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                Text(
                                  'Count: ${adoption['petCount']} pet(s)',
                                  style: GoogleFonts.cabin(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSimpleAdoption(
                                adoption['id'],
                                adoption['name'] ?? 'Unknown',
                              ),
                              tooltip: 'Cancel Adoption',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
    );
  }
}
