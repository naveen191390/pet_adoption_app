import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/view_model/pet_provider.dart';
import 'package:pet_app/view/adopt_details.dart';
import 'package:provider/provider.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

bool showUnfriendlyOnly = false;

class _PetListScreenState extends State<PetListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PetViewModel>(context, listen: false).fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    final petViewModel = Provider.of<PetViewModel>(context);

    if (petViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (petViewModel.pets.isEmpty) {
      return const Scaffold(body: Center(child: Text("No pets found")));
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 206, 142),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 255, 206, 142),
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Adopt",
              style: GoogleFonts.cabin(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                "Your fav",
                style: GoogleFonts.cabin(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Icon(
                showUnfriendlyOnly ? Icons.pets : Icons.pets_outlined,
                color: showUnfriendlyOnly ? Colors.green : Colors.white,
              ),
              const SizedBox(width: 6),
              const Text("Friendly"),
              Switch(
                value: showUnfriendlyOnly,
                onChanged: (value) {
                  setState(() {
                    showUnfriendlyOnly = value;
                  });
                  petViewModel.filterFriendly(value);
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(
              height: 45,
              padding: const EdgeInsets.only(left: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  petViewModel.filterPets(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search by Pet Name',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: Image.asset('images/ffffrfffffffffff.png'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: petViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: petViewModel.pets.length,
                    itemBuilder: (context, index) {
                      final pet = petViewModel.pets[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdoptDetailsScreen(pet: pet),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 255, 247, 238),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: pet.petImage != null
                                      ? Image.network(
                                          pet.petImage!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (_, _, _) =>
                                              const Icon(Icons.pets, size: 50),
                                        )
                                      : const Icon(Icons.pets, size: 50),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                pet.petName ?? 'No Name',
                                style: GoogleFonts.cabin(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Owner: ${pet.userName ?? "Unknown"}',
                                style: GoogleFonts.cabin(fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                pet.isfriendly == true
                                    ? 'Friendly'
                                    : 'Unfriendly',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: pet.isfriendly == true
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pet_app/view_model/pet_provider.dart';
// import 'package:provider/provider.dart';

// class HomePaggee extends StatefulWidget {
//   const HomePaggee({super.key});

//   @override
//   State<HomePaggee> createState() => _HomePaggeeState();
// }

// class _HomePaggeeState extends State<HomePaggee> {
//   bool showFriendlyOnly = false;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<PetsProvider>(context, listen: false).loadPets();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final petsProvider = Provider.of<PetsProvider>(context);

//     if (petsProvider.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (petsProvider.pets.isEmpty) {
//       return const Scaffold(body: Center(child: Text("No pets found")));
//     }

//     final pets = showFriendlyOnly
//         ? petsProvider.pets.where((p) => p.isFriendly).toList()
//         : petsProvider.pets;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dogo"),
//         backgroundColor: const Color.fromARGB(255, 255, 206, 142),
//         actions: [
//           Row(
//             children: [
//               Icon(
//                 showFriendlyOnly ? Icons.pets : Icons.pets_outlined,
//                 color: showFriendlyOnly ? Colors.green : Colors.grey,
//               ),
//               const SizedBox(width: 6),
//               const Text("Friendly"),
//               Switch(
//                 value: showFriendlyOnly,
//                 onChanged: (val) {
//                   setState(() {
//                     showFriendlyOnly = val;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(right: 390),
//             child: Text("Adopt", style: GoogleFonts.cabin(fontSize: 30)),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 300),
//             child: Text("Your fav", style: GoogleFonts.cabin(fontSize: 25)),
//           ),
//           SizedBox(height: 10),

//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(10),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 15,
//                 mainAxisSpacing: 15,
//                 childAspectRatio: 0.8,
//               ),
//               itemCount: pets.length,
//               itemBuilder: (context, index) {
//                 final pet = pets[index];

//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 4,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(15),
//                           ),
//                           child: Image.network(
//                             pet.petImage,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             errorBuilder: (_, __, ___) =>
//                                 const Icon(Icons.error),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         pet.petName,
//                         style: GoogleFonts.cabin(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
