class Recipe {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final int portions;
  final List<String> ingredients;
  final String category;
  final String imagePath;
  final List<String> steps;

  bool isFavorite;
  bool isSaved;
  bool isFinished;

  Recipe({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.portions,
    required this.ingredients,
    required this.category,
    required this.imagePath,
    required this.steps,
    this.isFavorite = false,
    this.isSaved = true,
    this.isFinished = false,
  });
}
