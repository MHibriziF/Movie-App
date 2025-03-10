import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/mainscreens/movie_details_screen.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/widgets/movies/movie_tiles.dart';

enum MovieGenre {
  action(28, "Action"),
  adventure(12, "Adventure"),
  animation(16, "Animation"),
  comedy(35, "Comedy"),
  crime(80, "Crime"),
  documentary(99, "Documentary"),
  drama(18, "Drama"),
  family(10751, "Family"),
  fantasy(14, "Fantasy"),
  history(36, "History"),
  horror(27, "Horror"),
  music(10402, "Music"),
  mystery(9648, "Mystery"),
  romance(10749, "Romance"),
  scienceFiction(878, "Science Fiction"),
  tvMovie(10770, "TV Movie"),
  thriller(53, "Thriller"),
  war(10752, "War"),
  western(37, "Western");

  final int id;
  final String name;

  const MovieGenre(this.id, this.name);

  static MovieGenre? fromId(int id) {
    return MovieGenre.values.firstWhere((genre) => genre.id == id);
  }
}

enum MovieSort {
  voteAverage("vote_average", "Vote Average"),
  voteCount("vote_count", "Vote Count"),
  popularity("popularity", "Popularity"),
  title("original_title", "Title");

  final String value;
  final String name;

  const MovieSort(this.value, this.name);
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<MovieGenre> _selectedGenres = [];
  int currentPage = 1;
  int totalPages = 0;
  MovieSort _selectedSort = MovieSort.popularity;
  bool _isAscending = false;

  Future<List<Movie>> fetchMovies() async {
    if (_selectedGenres.isEmpty) return [];
    final genreIds = _selectedGenres.map((genre) => genre.id).join(",");
    final sortOrder = _isAscending ? "asc" : "desc";
    final movieDatas = await ApiServices.getMoviesByGenres(
        genreIds, currentPage, "${_selectedSort.value}.$sortOrder");

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

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Sort Movies",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<MovieSort>(
                value: _selectedSort,
                onChanged: (newValue) {
                  _selectedSort = newValue!;
                  Navigator.of(context).pop();
                  _showSortDialog();
                },
                items: MovieSort.values.map((sort) {
                  return DropdownMenuItem(
                    value: sort,
                    child: Text(
                      sort.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ascending"),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Switch(
                        value: _isAscending,
                        onChanged: (value) {
                          setState(() {
                            _isAscending = value;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  currentPage = 1;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover movies from your favorite genres",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MovieGenre.values.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return ChoiceChip(
                    label: Text(genre.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                          currentPage = 1;
                        } else {
                          _selectedGenres.remove(genre);
                          currentPage = 1;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showSortDialog,
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Movie>>(
                future: fetchMovies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Details not available'));
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('No movies found'));
                  }

                  return Column(
                    children: [
                      ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true, // Prevents unnecessary scrolling
                        physics:
                            const NeverScrollableScrollPhysics(), // Disables internal scroll
                        itemBuilder: (context, index) {
                          final movie = snapshot.data![index];
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsScreen(movie: movie),
                              ),
                            ),
                            child: MovieTiles(movie: movie),
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
                        )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
