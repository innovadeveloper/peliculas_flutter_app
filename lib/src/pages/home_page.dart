import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  /*
   * retorna el tamanio total de la pantalla sin considerar el tamanio del appbar y
   * la barra de notificaciones o notch..
   */
  double _screenTotalSize(AppBar appBar, MediaQueryData mediaQueryData) {
    return (mediaQueryData.size.height -
        appBar.preferredSize.height -
        mediaQueryData.padding.top);
  }

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    var mediaQuery = MediaQuery.of(context);

    var appBar = AppBar(
      centerTitle: false,
      title: Text('Películas en cines'),
      backgroundColor: Colors.indigoAccent,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: DataSearch(),
              // query: 'Hola'
            );
          },
        )
      ],
    );

    return SafeArea(
      child: Scaffold(
          appBar: appBar,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _swiperTarjetas(appBar, mediaQuery),
                _footer(context, appBar, mediaQuery)
              ],
            ),
          )),
    );
  }

  Widget _swiperTarjetas(AppBar appBar, MediaQueryData mediaQuery) {
    return Container(
      // color: Colors.red,
      height: _screenTotalSize(appBar, mediaQuery) * 0.7, // max
      child: FutureBuilder(
        future: peliculasProvider.getEnCines(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(peliculas: snapshot.data);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  Widget _footer(
      BuildContext context, AppBar appBar, MediaQueryData mediaQuery) {
    return Container(
      // color: Colors.green,
      width: double.infinity,
      height: _screenTotalSize(appBar, mediaQuery) * 0.3, // max
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                  appBar: appBar,
                  mediaQuery: mediaQuery,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
