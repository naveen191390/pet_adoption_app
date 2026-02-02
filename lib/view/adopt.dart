import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/database/db.dart';
import 'package:pet_app/model/adoption_model.dart';
import 'package:pet_app/view_model/pet_provider.dart';
import 'package:provider/provider.dart';

class Adoptt extends StatefulWidget {
  const Adoptt({super.key});

  @override
  State<Adoptt> createState() => _AdopttState();
}

class _AdopttState extends State<Adoptt> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String selectedCategory = 'All';
  String selectedGender = "Male";
  int petCount = 1;
  List<String> selectedPets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 234, 207),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 234, 207),
        title: Text(
          'A forever home starts here',
          style: GoogleFonts.epilogue(fontSize: 22),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 0),
                child: Text("Category", style: GoogleFonts.lato(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 2,
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Pets')),
                    DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                    DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                    DropdownMenuItem(value: 'Rabbit', child: Text('Rabbit')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    if (value == "Cat" || value == "Rabbit") {
                      _showUnavailableAlert(value);
                    } else {
                      setState(() {
                        selectedCategory = value;
                        selectedPets.clear();
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text("Name", style: GoogleFonts.lato(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 2,
                ),
                child: TextFormField(
                  controller: nameController,
                  validator: (v) => v!.isEmpty ? "Enter Name" : null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter Your Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text("Age", style: GoogleFonts.lato(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 2,
                ),
                child: TextFormField(
                  controller: ageController,
                  validator: (v) => v!.isEmpty ? "Enter Age" : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Your Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text("Gender", style: GoogleFonts.lato(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 234, 207),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: ["Male", "Female", "Other"].map((gender) {
                      final isSelected = selectedGender == gender;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => selectedGender = gender);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              gender,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "Number of pets",
                  style: GoogleFonts.lato(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 150, left: 25),
                child: DropdownButtonFormField<int>(
                  value: petCount,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: List.generate(
                    5,
                    (i) =>
                        DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                  ),
                  onChanged: (v) => setState(() => petCount = v!),
                ),
              ),

              if (selectedCategory == "Dog") ...[
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    "Select Pets",
                    style: GoogleFonts.lato(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 8),

                Consumer<PetViewModel>(
                  builder: (context, petVM, child) {
                    final dogs = petVM.pets
                        .where((p) => p.category == "Dog")
                        .toList();

                    if (dogs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No dogs available"),
                      );
                    }

                    return SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemCount: dogs.length,
                        itemBuilder: (context, index) {
                          final pet = dogs[index];
                          final isSelected = selectedPets.contains(pet.petName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedPets.remove(pet.petName);
                                } else {
                                  if (selectedPets.length < petCount) {
                                    selectedPets.add(pet.petName!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "You can only select $petCount pets",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              });
                            },
                            child: Container(
                              width: 110,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        pet.petImage ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.pets, size: 50),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    pet.petName ?? "",
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                if (selectedPets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 8),
                    child: Wrap(
                      spacing: 6,
                      children: selectedPets
                          .map((pet) => Chip(label: Text(pet)))
                          .toList(),
                    ),
                  ),
              ],

              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _confirmAdoption,
                        child: const Text("Confirm"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _saveDirect,
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 150, top: 30),
                      child: SizedBox(
                        height: 170,
                        width: 350,
                        child: Image.asset("images/uhhhhh.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAdoption() async {
    final adoption = Adoption(
      name: nameController.text,
      age: int.parse(ageController.text),
      gender: selectedGender,
      petCount: petCount,
      petName: selectedPets.join(", "),
    );
    await DBHelper.insertAdoption(adoption);
  }

  void _saveDirect() async {
    if (_formKey.currentState!.validate()) {
      await _saveAdoption();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Saved 💾")));
      }
    }
  }

  void _confirmAdoption() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Confirm Adoption 🐾"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _saveAdoption();
                _showSuccessDialog();
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success 🎉"),
        content: const Text("Adoption Saved!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showUnavailableAlert(String category) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Icon(Icons.pets, color: Colors.orange),
              const SizedBox(width: 8),
              const Text(
                "Service Unavailable",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "$category adoption is currently unavailable.\nPlease try again later.",
            style: TextStyle(fontSize: 14, color: Colors.brown[700]),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.orange),
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
        setState(() => selectedCategory = 'All');
      }
    });
  }
}
