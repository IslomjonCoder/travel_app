import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/main/favourite/data/data_sources/favourite_service.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  final FavouritesService favouriteService;

  FavouriteCubit(this.favouriteService) : super(FavouriteState());

  getFavourites() {
    final favourites = favouriteService.getFavourites();
    emit(FavouriteState(places: favourites));
  }
  toggleFavourite(PlaceModel favourite) {
    if (isFavourite(favourite)) {
      removeFavourite(favourite.id.toString());
    } else {
      addFavourite(favourite);
    }
  }
  addFavourite(PlaceModel favourite) {
    favouriteService.addFavourite(favourite);
    getFavourites();
  }

  removeFavourite(String itemId) {
    favouriteService.removeFavourite(itemId);
    getFavourites();
  }

  isFavourite(PlaceModel favourite) {
    return state.places.map((e) => e.id).contains(favourite.id);
  }


  getPlacesListByCategory(int id) {
    final favourites = state.places
        .where((element) => element.category.id == id)
        .toList();
    emit(FavouriteState(places: favourites));
  }
}
