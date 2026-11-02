import 'package:flutter_riverpod/legacy.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super(dummyMeals);

  bool addMeal(Meal m) {
    final mealExists = state.contains(m);

    if (mealExists) return false;

    state = [...state, m];

    return true;
  }

  bool removeMeal(Meal m) {
    final mealExists = state.contains(m);

    if (!mealExists) return false;

    state = state.where((meal) => m.id != meal.id).toList();

    return true;
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  return MealsNotifier();
});
