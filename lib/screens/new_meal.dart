import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/meals_provider.dart';

class NewMealScreen extends ConsumerStatefulWidget {

  const NewMealScreen({super.key});

  @override
  ConsumerState<NewMealScreen> createState() {
    return _NewMealScreenState();
  }
}

class _NewMealScreenState extends ConsumerState<NewMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _durationController = TextEditingController();

  final List<String> _ingredients = [];
  final List<String> _steps = [];
  final List<String> _selectedCategories = [];

  Complexity _selectedComplexity = Complexity.simple;
  Affordability _selectedAffordability = Affordability.affordable;

  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  bool _isVegan = false;
  bool _isVegetarian = false;

  final _ingredientController = TextEditingController();
  final _stepController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _durationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _imageUrlController.text = 'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1280px-Good_Food_Display_-_NCI_Visuals_Online.jpg?utm_source=en.wikipedia.org&utm_campaign=imageinfo&utm_content=thumbnail';
    super.initState();
  }

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim();

    if (ingredient.isEmpty) return;

    setState(() {
      _ingredients.add(ingredient);
      _ingredientController.clear();
    });
  }

  void _addStep() {
    final step = _stepController.text.trim();
    if (step.isEmpty) return;
    setState(() {
      _steps.add(step);
      _stepController.clear();
    });
  }

  void _addCategory() {}

  void _submitForm(WidgetRef ref) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_ingredients.isEmpty || _steps.isEmpty) return;

    final newMeal = Meal(
      id: DateTime.now().toString(),
      categories: List.from(_selectedCategories),
      title: _titleController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      ingredients: List.from(_ingredients),
      steps: List.from(_steps),
      duration: int.parse(_durationController.text),
      complexity: _selectedComplexity,
      affordability: _selectedAffordability,
      isGlutenFree: _isGlutenFree,
      isLactoseFree: _isLactoseFree,
      isVegan: _isVegan,
      isVegetarian: _isVegetarian,
    );

    ref.read(mealsProvider.notifier).addMeal(newMeal);

    print(mealsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Meal')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Meal Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Please enter a meal title';
                  return null;
                },
                style: Theme.of(context).textTheme.titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Please enter an image URL.';

                  final uri = Uri.tryParse(value.trim());
                  if (uri == null ||
                      !uri.hasScheme ||
                      !['http', 'https'].contains(uri.scheme) ||
                      uri.host.isEmpty)
                    return 'Please enter a valid image URL.';
                  return null;
                },
                style: Theme.of(context).textTheme.titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final duration = int.tryParse(value ?? '');
                  if (duration == null || duration <= 0)
                    return 'Please enter a valid duration.';
                  return null;
                },
                style: Theme.of(context).textTheme.titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),

              Column(
                children: [
                  TextField(
                    controller: _ingredientController,
                    decoration: InputDecoration(
                      labelText: 'Ingredient',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addIngredient,
                      ),
                    ),
                    onSubmitted: (_) => _addIngredient(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  ..._ingredients.asMap().entries.map((entry) {
                    final index = entry.key;
                    final ingredient = entry.value;
                    return ListTile(
                      title: Text(ingredient),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _ingredients.removeAt(index);
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
              Column(
                children: [
                  TextField(
                    controller: _stepController,
                    decoration: InputDecoration(
                      labelText: 'Step',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addStep,
                      ),
                    ),
                    onSubmitted: (_) => _addStep(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  ..._steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return ListTile(
                      title: Text(step),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _steps.removeAt(index);
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
              DropdownButtonFormField<Complexity>(
                decoration: InputDecoration(labelText: 'Complexity'),
                initialValue: _selectedComplexity,
                items: Complexity.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedComplexity = value;
                  });
                },
                style: Theme.of(context).textTheme.titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              SwitchListTile(
                value: _isGlutenFree,
                onChanged: (isChecked) {
                  setState(() {
                    _isGlutenFree = isChecked;
                  });
                },
                title: Text(
                  'Gluten-free',
                  style: Theme.of(context).textTheme.titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                subtitle: Text(
                  'This meal is gluten-free.',
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                activeThumbColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: EdgeInsets.only(left: 34, right: 22),
              ),
              SwitchListTile(
                value: _isLactoseFree,
                onChanged: (isChecked) {
                  setState(() {
                    _isLactoseFree = isChecked;
                  });
                },
                title: Text(
                  'Lactose-free',
                  style: Theme.of(context).textTheme.titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                subtitle: Text(
                  'This meal is lactose-free.',
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                activeThumbColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: EdgeInsets.only(left: 34, right: 22),
              ),
              SwitchListTile(
                value: _isVegetarian,
                onChanged: (isChecked) {
                  setState(() {
                    _isVegetarian = isChecked;
                  });
                },
                title: Text(
                  'Vegetarian',
                  style: Theme.of(context).textTheme.titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                subtitle: Text(
                  'This meal is vegetarian.',
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                activeThumbColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: EdgeInsets.only(left: 34, right: 22),
              ),
              SwitchListTile(
                value: _isVegan,
                onChanged: (isChecked) {
                  setState(() {
                    _isVegan = isChecked;
                  });
                },
                title: Text(
                  'Vegan',
                  style: Theme.of(context).textTheme.titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                subtitle: Text(
                  'This meal is vegan.',
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                activeThumbColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: EdgeInsets.only(left: 34, right: 22),
              ),
              ElevatedButton(
                onPressed: () {
                  print("submit fired");
                  _submitForm(ref);
                },
                child: const Text('Add Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
