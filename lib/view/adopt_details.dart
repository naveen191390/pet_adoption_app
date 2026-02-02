import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/database/db.dart';

class AdoptDetailsScreen extends StatefulWidget {
  final dynamic pet;

  const AdoptDetailsScreen({super.key, required this.pet});

  @override
  State<AdoptDetailsScreen> createState() => _AdoptDetailsScreenState();
}

class _AdoptDetailsScreenState extends State<AdoptDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final reasonController = TextEditingController();

  void saveAdoption() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Adoption"),
        content: Text("Are you sure you want to adopt ${widget.pet.petName}?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Yes, Confirm"),
            onPressed: () async {
              Navigator.pop(context);

              await DBHelper.insertDetailedAdoption({
                'petName': widget.pet.petName,
                'petImage': widget.pet.petImage,
                'ownerName': widget.pet.userName,
                'adopterName': nameController.text,
                'phone': phoneController.text,
                'address': addressController.text,
                'reason': reasonController.text,
                'adoptionDate': DateTime.now().toString(),
              });

              if (widget.pet.id != null) {
                await DBHelper.markPetAdopted(widget.pet.id);
              }

              if (mounted) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("🎉 Success"),
                    content: Text(
                      "${widget.pet.petName} is now adopted by you!",
                    ),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 206, 142),
      appBar: AppBar(
        title: const Text("Adopt Details"),
        backgroundColor: const Color.fromARGB(255, 255, 206, 142),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.network(
                      pet.petImage ?? '',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.pets, size: 50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pet.petName ?? 'Unknown',
                    style: GoogleFonts.cabin(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Owner: ${pet.userName ?? 'Unknown'}"),
                  Text(
                    pet.isfriendly == true ? "Friendly" : "Unfriendly",
                    style: TextStyle(
                      color: pet.isfriendly == true ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildField("Your Name", nameController),
                  buildField("Phone Number", phoneController, isPhone: true),
                  buildField("Address", addressController),
                  buildField(
                    "Reason (Optional)",
                    reasonController,
                    requiredField: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: saveAdoption,
              child: const Text(
                "CONFIRM & SAVE ADOPTION",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    bool isPhone = false,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (!requiredField) return null;
          if (value == null || value.isEmpty) return "Required field";
          if (isPhone && value.length != 10) return "Enter valid phone number";
          return null;
        },
      ),
    );
  }
}
