import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/providers/api_provider.dart';
import 'package:rickandmorty/widgets/search_delegate.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context,listen: false);
    apiProvider.getCharacters(page);
    scrollController.addListener(() async {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("RICK & MORTY",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
              showSearch(context: context, delegate: SearchCharacter());
          } , icon: const Icon(Icons.search))
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: apiProvider.characters.isNotEmpty
            ? CharacterList(
          apiProvider: apiProvider, scrollController: scrollController, isLoading: isLoading,)
            : const Center(child: CircularProgressIndicator(),
            ),
           )
         );
        }
  }
  
  class CharacterList extends StatelessWidget {
    const CharacterList({super.key, required this.apiProvider, required this.scrollController, required this.isLoading});

    final ApiProvider apiProvider;
    final ScrollController scrollController;
    final bool isLoading;
    @override
    Widget build(BuildContext context) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.87,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
        ),
        itemCount: isLoading ? apiProvider.characters.length + 2 : apiProvider.characters.length,
        controller: scrollController,
        itemBuilder: (context,index){
      if(index < apiProvider.characters.length){
        final character = apiProvider.characters[index];
          return GestureDetector(
            child: Card(
            child: Column(
              children: [
                Hero(
                  tag: character.id!,
                    child: FadeInImage(placeholder: AssetImage('assets/images/portal-rick-and-morty.gif'), image: NetworkImage(character.image!))),
                Text(character.name!, style: TextStyle(fontSize: 16,overflow: TextOverflow.ellipsis),),
              ],
            ),
           ),
             onTap: () {
              context.go('/character',extra: character);
             },
          );
      }else{
        return const Center(child: CircularProgressIndicator());
      }
        },
      );
    }
  }
  

