import 'dart:async';
import 'dart:math' show max;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/config/durations.dart';
import 'package:pokedex/config/images.dart';
import 'package:pokedex/core/extensions/animation.dart';
import 'package:pokedex/core/extensions/context.dart';
import 'package:pokedex/modals/generation_modal.dart';
import 'package:pokedex/modals/searchModal.dart';
import 'package:pokedex/widgets/fab.dart';

import 'bloc/navCubit.dart';
import 'bloc/pokemonBloc.dart';
import 'bloc/pokemonState.dart';
part 'package:pokedex/Widget/fabmenu.dart';


class PokedexScreen extends StatefulWidget {
  const PokedexScreen();

  @override
  State<StatefulWidget> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> with SingleTickerProviderStateMixin {
  static const double _endReachedThreshold = 200;

  final ScrollController _scrollController = ScrollController();

  Animation<double> _fabAnimation;
  AnimationController _fabController;
  bool _isFabMenuVisible = false;

  @override
  void initState() {
    _fabController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    _fabAnimation = _fabController.curvedTweenAnimation(
      begin: 0.0,
      end: 1.0,
    );



  
    super.initState();
  }

  @override
  void dispose() {
    _fabController?.dispose();
    _scrollController?.dispose();

    super.dispose();
  }

  void _toggleFabMenu() {
    _isFabMenuVisible = !_isFabMenuVisible;

    if (_isFabMenuVisible) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }



  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchBottomModal(),
    );
  }
  void _showGenerationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GenerationModal(),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(
        left: 26,
        right: 26,
        top: context.responsive(18),
        bottom: context.responsive(4),
      ),
      child: Text(
        'Pokemon',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    showModalBottomSheet;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('POKEDEX'),
        backgroundColor: Colors.lightBlue,
      ),
      
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          else if (state is PokemonPageLoadSuccess) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),

              gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),

                itemCount: state.pokemonListings.length,
                itemBuilder: (context, index) {

                  return GestureDetector(
                    onTap: () => BlocProvider.of<NavCubit>(context)
                    .showPokemonDetails(state.pokemonListings[index].id),
                    child: Card(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: InkWell(
                    splashColor: Colors.lightBlue.withAlpha(30),

                    child: GridTile(
                      child: Column(
                        children: [
                          Image.network(state.pokemonListings[index].imageUrl),
                          Text(state.pokemonListings[index].name)
                        ],
                      ),
                    ),

                  ),
                ),
              );
            },
          );
        } 
          
        else if (state is PokemonPageLoadFailed) {
          return Center(
            child: Text(state.error.toString()),
          );
        } 
          
        else {
          return Container();
        }
      },
    ),
      floatingActionButton: _FabMenu(
        animation: _fabAnimation,
        toggle: _toggleFabMenu,
        onSearchPress: _showSearchModal,
      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
