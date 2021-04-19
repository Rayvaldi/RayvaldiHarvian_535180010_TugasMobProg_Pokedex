import 'appNav.dart';
import 'bloc/pokemonBloc.dart';
import 'bloc/pokemonDetails.dart';
import 'bloc/pokemonEvent.dart';
import 'bloc/navCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final pokemonDetailsCubit = PokemonDetailsCubit();

    return MaterialApp(
      theme: Theme.of(context)
          .copyWith(primaryColor: Colors.green, accentColor: Colors.greenAccent),
          debugShowCheckedModeBanner: false,
          
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
              PokemonBloc()..add(PokemonPageRequest(page: 0))),
        
          BlocProvider(
            create: (context) =>
              NavCubit(pokemonDetailsCubit: pokemonDetailsCubit)),
        
          BlocProvider(
            create: (context) => pokemonDetailsCubit)
        ], 
        
        child: AppNavigator()
      ),
    );
  }
}
