import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/bloc/navCubit.dart';
import 'package:pokedex/bloc/pokemonDetails.dart';
import 'package:pokedex/data/pokeRepository.dart';
import 'package:pokedex/data/pokeSpecies.dart';
import 'package:pokedex/pokedex.dart';
import 'bloc/pokemonBloc.dart';
import 'bloc/pokemonState.dart';
import 'config/durations.dart';
import 'modals/searchModal.dart';
import 'package:pokedex/modals/searchModal.dart';
import 'package:pokedex/widgets/fab.dart';
import 'package:pokedex/core/extensions/context.dart';

class PokedexView extends StatelessWidget {
   static const double _endReachedThreshold = 200;

  final ScrollController _scrollController = ScrollController();

  Animation<double> _fabAnimation;
  AnimationController _fabController;
  bool _isFabMenuVisible = false;

  get context => null;


  @override
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
      context : context,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchBottomModal(),
    );
  }


  @override
  Widget build(BuildContext context) {

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
      floatingActionButton: FloatingActionButton(
      child: Icon(
        Icons.search), 
        onPressed: (){},
      ),
      
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
    
   }
     
       
}