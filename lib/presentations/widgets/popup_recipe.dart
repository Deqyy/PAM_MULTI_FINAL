import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopupRecipe extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String time;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;

  const PopupRecipe({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.description,
    required this.ingredients,
    required this.instructions,
  });

  @override
  _PopupRecipeState createState() => _PopupRecipeState();
}

class _PopupRecipeState extends State<PopupRecipe> {
  bool showIngredients = true;
  bool isIconPressed = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: screenHeight,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 250.0,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    left: 15.0,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    right: 15.0,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isIconPressed = !isIconPressed;
                          });
                        },
                        child: SvgPicture.asset(
                          isIconPressed
                              ? 'assets/icons/blue_heart.svg'
                              : 'assets/icons/heart.svg',
                          height: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/clock.svg',
                              height: 20.0,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              widget.time,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: Color(0xFF748189),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        color: Color(0xFF748189),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EBF2),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildToggleButton(
                              title: 'Bahan',
                              isActive: showIngredients,
                              onTap: () {
                                setState(() {
                                  showIngredients = true;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: _buildToggleButton(
                              title: 'Instruksi',
                              isActive: !showIngredients,
                              onTap: () {
                                setState(() {
                                  showIngredients = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      showIngredients ? 'Bahan-bahan' : 'Instruksi',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    showIngredients
                        ? _buildBulletList(widget.ingredients)
                        : _buildBulletList(widget.instructions),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF042628) : const Color(0xFFE6EBF2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              const Text(
                '•',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF748189),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  items[index],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Color(0xFF748189),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
