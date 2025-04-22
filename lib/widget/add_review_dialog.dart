import 'package:flutter/material.dart';

class AddReviewDialog extends StatefulWidget {
  final Function(double rating, String comment) onSubmit;

  const AddReviewDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  double _rating = 0.0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(maxWidth * 0.04),
          ),
          child: Padding(
            padding: EdgeInsets.all(maxWidth * 0.04),
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
                          fontSize: maxWidth * 0.035,
                        ),
                      ),
                    ),
                    Text(
                      'Escribir reseña',
                      style: TextStyle(
                        fontSize: maxWidth * 0.035,
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
                          fontSize: maxWidth * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: maxHeight * 0.02),
                
                // Estrellas para calificar
                Text(
                  'Toca para calificar:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: maxWidth * 0.03,
                  ),
                ),
                
                SizedBox(height: maxHeight * 0.01),
                
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
                        size: maxWidth * 0.08,
                      ),
                    );
                  }),
                ),
                
                SizedBox(height: maxHeight * 0.02),
                
                // Campo de reseña
                TextField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu reseña aquí...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(maxWidth * 0.03),
                    ),
                    contentPadding: EdgeInsets.all(maxWidth * 0.04),
                    hintStyle: TextStyle(
                      fontSize: maxWidth * 0.035,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: maxWidth * 0.035,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}