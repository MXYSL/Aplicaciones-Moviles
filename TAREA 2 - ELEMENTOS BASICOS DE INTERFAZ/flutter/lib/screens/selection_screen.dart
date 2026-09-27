// Screen 3 Selección
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  bool? _optionalIngredients = false;
  String _meal = 'Comida';
  bool _vegetarianOnly = false;

  double _portions = 4;
  RangeValues _preparationTime = const RangeValues(15, 60);

  String _cuisine = 'Mexicana';

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final Set<String> _selectedFilters = {'Rápido'};

  final List<String> _filters = [
    'Rápido',
    'Saludable',
    'Vegetariano',
    'Económico',
    'Sin horno',
    'Favoritos',
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2, 12, 31),
      helpText: 'Selecciona una fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (date == null) {
      return;
    }

    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 14, minute: 0),
      helpText: 'Selecciona una hora',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (time == null) {
      return;
    }

    setState(() {
      _selectedTime = time;
    });
  }

  String _formatDate(DateTime date) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  void _applyPreferences() {
    final filters = _selectedFilters.isEmpty
        ? 'Sin filtros'
        : _selectedFilters.join(', ');

    _showMessage(
      'Menú actualizado: ${_portions.round()} porciones • '
      '$_meal • $filters',
    );
  }

  IconData _filterIcon(String filter) {
    switch (filter) {
      case 'Rápido':
        return Icons.bolt_rounded;
      case 'Saludable':
        return Icons.favorite_outline_rounded;
      case 'Vegetariano':
        return Icons.eco_outlined;
      case 'Económico':
        return Icons.savings_outlined;
      case 'Sin horno':
        return Icons.no_food_outlined;
      case 'Favoritos':
        return Icons.star_outline_rounded;
      default:
        return Icons.tune_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personaliza tu menú')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Prepara el menú a tu gusto',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Selecciona tus preferencias para encontrar recetas '
            'que se adapten a lo que necesitas.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Ingredientes opcionales',
            description:
                'Decide si FoodLab puede incluir ingredientes '
                'adicionales en tus recetas.',
          ),

          Card(
            child: CheckboxListTile(
              value: _optionalIngredients,
              tristate: true,
              title: Text(
                _optionalIngredients == true
                    ? 'Incluir ingredientes opcionales'
                    : _optionalIngredients == false
                    ? 'No incluir ingredientes opcionales'
                    : 'Decidir en cada receta',
              ),
              subtitle: Text(
                _optionalIngredients == null
                    ? 'FoodLab te preguntará antes de agregarlos.'
                    : _optionalIngredients == true
                    ? 'Se podrán mostrar complementos y sugerencias.'
                    : 'Solo se considerarán los ingredientes principales.',
              ),
              secondary: const Icon(Icons.add_circle_outline_rounded),
              onChanged: (value) {
                setState(() {
                  _optionalIngredients = value;
                });
              },
            ),
          ),

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Momento del día',
            description:
                'Selecciona cuándo planeas disfrutar tu próxima receta.',
          ),

          // RadioGroup administra la selección de los tres RadioListTile.
          Card(
            child: RadioGroup<String>(
              groupValue: _meal,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _meal = value;
                });
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    value: 'Desayuno',
                    title: Text('Desayuno'),
                    secondary: Icon(Icons.free_breakfast_outlined),
                  ),
                  Divider(height: 1),
                  RadioListTile<String>(
                    value: 'Comida',
                    title: Text('Comida'),
                    secondary: Icon(Icons.lunch_dining_outlined),
                  ),
                  Divider(height: 1),
                  RadioListTile<String>(
                    value: 'Cena',
                    title: Text('Cena'),
                    secondary: Icon(Icons.dinner_dining_outlined),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Preferencia vegetariana',
            description: 'Activa esta opción para priorizar recetas sin carne.',
          ),

          Card(
            child: SwitchListTile(
              value: _vegetarianOnly,
              title: const Text('Mostrar solo recetas vegetarianas'),
              subtitle: Text(
                _vegetarianOnly
                    ? 'Las recetas con carne quedarán fuera '
                          'de tus resultados.'
                    : 'Se mostrarán recetas de todos los tipos.',
              ),
              secondary: const Icon(Icons.eco_outlined),
              onChanged: (value) {
                setState(() {
                  _vegetarianOnly = value;
                });
              },
            ),
          ),

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Número de porciones',
            description:
                'Ajusta la cantidad de personas para las que deseas cocinar.',
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people_outline_rounded),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${_portions.round()} porciones',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _portions,
                    min: 1,
                    max: 12,
                    divisions: 11,
                    label: '${_portions.round()} porciones',
                    onChanged: (value) {
                      setState(() {
                        _portions = value;
                      });
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('1'), Text('12')],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Tiempo disponible',
            description:
                'Indica el rango de tiempo que puedes dedicar a cocinar.',
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${_preparationTime.start.round()} a '
                          '${_preparationTime.end.round()} minutos',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _preparationTime,
                    min: 10,
                    max: 120,
                    divisions: 11,
                    labels: RangeLabels(
                      '${_preparationTime.start.round()} min',
                      '${_preparationTime.end.round()} min',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _preparationTime = values;
                      });
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('10 min'), Text('120 min')],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Tipo de cocina',
            description: 'Elige el estilo de comida que deseas preparar.',
          ),

          DropdownButtonFormField<String>(
            initialValue: _cuisine,
            decoration: const InputDecoration(
              labelText: 'Cocina preferida',
              prefixIcon: Icon(Icons.public_rounded),
            ),
            items: const [
              DropdownMenuItem(value: 'Mexicana', child: Text('Mexicana')),
              DropdownMenuItem(value: 'Italiana', child: Text('Italiana')),
              DropdownMenuItem(value: 'Asiática', child: Text('Asiática')),
              DropdownMenuItem(
                value: 'Mediterránea',
                child: Text('Mediterránea'),
              ),
              DropdownMenuItem(
                value: 'Internacional',
                child: Text('Internacional'),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _cuisine = value;
              });
            },
          ),

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Programa tu comida',
            description:
                'Selecciona el día y la hora en que planeas '
                'preparar tu receta.',
          ),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Elegir fecha'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectTime,
                  icon: const Icon(Icons.access_time_rounded),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Elegir hora'),
                  ),
                ),
              ),
            ],
          ),

          if (_selectedDate != null || _selectedTime != null) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_available_rounded),
                title: const Text('Comida programada'),
                subtitle: Text(
                  [
                    if (_selectedDate != null) _formatDate(_selectedDate!),
                    if (_selectedTime != null)
                      'a las ${_formatTime(_selectedTime!)}',
                  ].join(' '),
                ),
                trailing: IconButton(
                  tooltip: 'Quitar programación',
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                      _selectedTime = null;
                    });
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),

          const _SectionTitle(
            title: 'Filtros para tus recetas',
            description:
                'Marca una o varias opciones para personalizar '
                'tus resultados.',
          ),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final filter in _filters)
                FilterChip(
                  label: Text(filter),
                  selected: _selectedFilters.contains(filter),
                  avatar: Icon(_filterIcon(filter), size: 18),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add(filter);
                      } else {
                        _selectedFilters.remove(filter);
                      }
                    });
                  },
                ),
            ],
          ),

          const SizedBox(height: 32),

          FilledButton.icon(
            onPressed: _applyPreferences,
            icon: const Icon(Icons.tune_rounded),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Aplicar preferencias'),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String description;

  const _SectionTitle({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
