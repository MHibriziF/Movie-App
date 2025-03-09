import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/mainscreens/movie_details_screen.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/widgets/movie_backdrop.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onSubmitted: (string) => setState(() {}),
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search Movies...",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => setState(() {}),
              ),
              iconColor: Theme.of(context).colorScheme.onPrimary,
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => _searchController.clear(),
              icon: Icon(Icons.close))
        ],
      ),
      body: FutureBuilder(
        future: ApiServices.searchMovie(_searchController.text),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Results.'));
          }
          List<Movie> movies = snapshot.data!;
          double height = MediaQuery.of(context).size.height * 0.4;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, ind) {
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MovieDetailsScreen(
                      movie: movies[ind],
                    ),
                  ),
                ),
                child: SizedBox(
                  height: height,
                  child: MovieBackdrop(movie: movies[ind]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
