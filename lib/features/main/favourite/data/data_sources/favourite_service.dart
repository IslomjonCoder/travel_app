import 'package:hive/hive.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';

class FavouritesService {
  final Box _favouritesBox = Hive.box('favouritesBox');

  List<PlaceModel> getFavourites() {
    return _favouritesBox.values.cast<PlaceModel>().toList();
  }

  void addFavourite(PlaceModel favourite) {

    _favouritesBox.put(favourite.id.toString(), favourite);
  }

  void removeFavourite(String itemId) {
    _favouritesBox.delete(itemId);
  }

  void clearFavourites() {
    _favouritesBox.clear();
  }
}