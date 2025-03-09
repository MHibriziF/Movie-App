import 'package:flutter/material.dart';
import 'package:movie_app/models/account.dart';
import 'package:movie_app/services/api_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Me"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiServices.getAccountDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else {
            Account account = snapshot.data!;
            String? avatarPath = account.avatar.tmdb.avatarPath;
            String avatarUrl = "";

            if (avatarPath != null && avatarPath.isNotEmpty) {
              avatarUrl = "https://image.tmdb.org/t/p/w500$avatarPath";
            } else if (account.avatar.gravatar.hash.isNotEmpty) {
              avatarUrl =
                  "https://www.gravatar.com/avatar/${account.avatar.gravatar.hash}";
            } else {
              avatarUrl =
                  "https://www.shutterstock.com/image-vector/avatar-gender-neutral-silhouette-vector-600nw-2470054311.jpg";
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50, // Increased size
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    account.username,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    account.name.isNotEmpty ? account.name : "-",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: const Text("Favorites"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to favorites screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list, color: Colors.blue),
                    title: const Text("Watchlist"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to watchlist screen
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
