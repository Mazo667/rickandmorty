import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_model.dart';
import 'package:rickandmorty/providers/api_provider.dart';
import 'package:rickandmorty/widgets/circle_loading.dart';

class SearchCharacter extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {
      query = '';
    }, icon: const Icon(Icons.clear)
    )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      close(context, null);
    }, icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final characterProvider = Provider.of<ApiProvider>(context);

    if(query.isEmpty){
      return circleLoading();
    }
    return FutureBuilder(
        future: characterProvider.getCharacter(query),
        builder: (context, AsyncSnapshot<List<Character>> snapshot){
          if(!snapshot.hasData){
            return circleLoading();
          }else{
            return ListView.builder(
              itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  final character = snapshot.data![index];
                    return ListTile(
                      onTap: (){
                        context.go('/character',extra: character);
                      },
                      title: Text(character.name!),
                      leading: Hero(tag: character.id!,child: CircleAvatar(backgroundImage: NetworkImage(character.image!))),
                    );
                });
          }
        }
        );
  }
}