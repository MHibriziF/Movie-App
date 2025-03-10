import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/mainscreens/movie_details_screen.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/widgets/movies/movie_backdrop.dart';
import 'package:movie_app/widgets/movies/movie_tiles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;

  Future<List<Movie>> fetchMovies() async {
    final movieDatas =
        await ApiServices.searchMovie(_searchController.text, currentPage);
    totalPages = movieDatas['total_pages'];
    return movieDatas['movies'];
  }

  void _nextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onSubmitted: (string) => setState(() {
              currentPage = 1;
            }),
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
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Results.'));
          }

          List<Movie> movies = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                ...movies.map(
                  (item) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsScreen(
                            movie: item,
                          ),
                        ),
                      ),
                      child: MovieTiles(movie: item),
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentPage != 1)
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          child: IconButton(
                            onPressed: _previousPage,
                            icon: Icon(Icons.navigate_before),
                          ),
                        ),
                      const SizedBox(width: 15),
                      Text(currentPage.toString()),
                      const SizedBox(width: 15),
                      if (currentPage != totalPages)
                        CircleAvatar(
                          child: IconButton(
                            onPressed: _nextPage,
                            icon: Icon(Icons.navigate_next),
                          ),
                        )
                    ],
                  ),
                const SizedBox(height: 10)
              ],
            ),
          );
        },
      ),
    );
  }
}
