import 'package:flutter/material.dart';


class AddReviewDialog extends StatefulWidget {
  final Function(double rating, String comment) onSubmit;

  const AddReviewDialog({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  double _rating = 0.0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  'Escribir reseña',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _rating > 0 && _commentController.text.isNotEmpty
                      ? () {
                          widget.onSubmit(_rating, _commentController.text);
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text(
                    'Enviar',
                    style: TextStyle(
                      color: _rating > 0 && _commentController.text.isNotEmpty
                          ? Colors.pink
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Estrellas para calificar
            Text(
              'Toca para calificar:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            
            // Campo de reseña
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Escribe tu reseña aquí...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (_) => setState(() {}), // Para actualizar el botón de enviar
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}