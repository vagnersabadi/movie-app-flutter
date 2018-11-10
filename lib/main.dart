import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movieModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

/**
 * Varaveis globais
 */
const baseUrl = "https://api.themoviedb.org/3/movie/";
const baseImageUrl = "https://image.tmdb.org/t/p/";
const apiKey = "aee0b4ecdda95b5452eb6648073fd6c6";

const nowPlayingUrl = "${baseUrl}now_playing?api_key=$apiKey";
const upcomingUrl = "${baseUrl}upcoming?api_key=$apiKey";
const popularUrl = "${baseUrl}popular?api_key=$apiKey";
const topRatedUrl = "${baseUrl}top_rated?api_key=$apiKey";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      home: MyMovieApp(),
    ));

class MyMovieApp extends StatefulWidget {
  @override
  _MyMovieApp createState() => new _MyMovieApp();
}

/**
 * Classe principal
 */
class _MyMovieApp extends State<MyMovieApp> {
  //Variaveis
  Movie nowPlayingMovies;
  Movie upcomingMovies;
  Movie popularMovies;
  Movie topRatedMovies;
  int heroTag = 0;

  @override
  void initState() {
    super.initState();
    /**
     * Inicializa funcções de buscas dos filmes
     */
    _fetchNowPlayingMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMovies();
  }

  /**
   * Busca os filmes assync
   */
  void _fetchNowPlayingMovies() async {
    var response = await http.get(nowPlayingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      nowPlayingMovies = Movie.fromJson(decodeJson);
      //print(decodeJson);
    });
  }

  void _fetchUpcomingMovies() async {
    var response = await http.get(upcomingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      upcomingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(popularUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchTopRatedMovies() async {
    var response = await http.get(topRatedUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodeJson);
    });
  }

/**
 * Carousel de imagens
*/
  Widget _buildCarouselSlider() => CarouselSlider(
        items: nowPlayingMovies == null
            ? <Widget>[Center(child: CircularProgressIndicator())]
            : nowPlayingMovies.results.map((movieItem) =>
                //Image.network("${baseImageUrl}w342${movieItem.posterPath}")
                _buildMovieItem(movieItem)).toList(),
        autoPlay: false,
        height: 240.0,
        viewportFraction: 0.5,
      );

  Widget _buildMovieItem(Results movieItem) {
    heroTag += 1;
    return Material(
      elevation: 15.0,
      child: InkWell(
        onTap: () {},
        child: Hero(
          tag: heroTag,
          child: Image.network("${baseImageUrl}w342${movieItem.posterPath}",
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildMovieListItem(Results movieItem) => Material(
        child: Container(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(6.0),
                  child: _buildMovieItem(movieItem)),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(movieItem.title,
                    style: TextStyle(fontSize: 8.0),
                    overflow: TextOverflow.ellipsis),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 6.0, top: 2.0),
                  child: Text(
                    movieItem.releaseDate,
                    style: TextStyle(fontSize: 8.0),
                  ))
            ],
          ),
        ),
      );

 Widget _buildMoviesListView(Movie movie, String movieListTitle) => Container(
        height: 258.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
              child: Text(movieListTitle,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400])),
            ),
            Flexible(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: movie == null
                  ? <Widget>[Center(child: CircularProgressIndicator())]
                  : movie.results
                      .map((movieItem) => Padding(
                            padding: EdgeInsets.only(left: 6.0, right: 2.0),
                            child: _buildMovieListItem(movieItem),
                          ))
                      .toList(),
            ))
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Movie App',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("NOW PLAYING",
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              expandedHeight: 290.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                          "${baseImageUrl}w500/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg",
                          fit: BoxFit.cover,
                          width: 1000.0,
                          colorBlendMode: BlendMode.dstATop,
                          color: Colors.blue.withOpacity(0.5)),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: _buildCarouselSlider())
                  ],
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            _buildMoviesListView(upcomingMovies, 'COMING SOON'),
            _buildMoviesListView(popularMovies, 'POPULAR'),
            _buildMoviesListView(topRatedMovies, 'TOP RATED'),
          ],
        ),
      ),
    );
  }
}
