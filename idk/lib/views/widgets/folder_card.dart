import 'dart:ui';
import 'package:flutter/material.dart';

class FolderCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final bool isListView;
  final String? route;

  const FolderCard({
    super.key,
    required this.title,
    required this.assetPath,
    this.isListView = false,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return isListView ? _buildListViewCard(context) : _buildGridViewCard(context);
  }

  Widget _buildGridViewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route != null && route!.isNotEmpty) {
          Navigator.pushNamed(context, route!);
        }
      },
      child: Column(
        children: [
          Container(
            width: 160, 
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Colors.white.withValues(alpha: 0.25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: assetPath.contains("DarkPurple") 
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple[400]!, Colors.purple[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.calculate,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Image.asset(assetPath, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListViewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route != null && route!.isNotEmpty) {
          Navigator.pushNamed(context, route!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withValues(alpha: 0.25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60, 
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withValues(alpha: 0.2),
              ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: assetPath.contains("DarkPurple") 
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[400]!, Colors.purple[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.calculate,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Image.asset(assetPath, fit: BoxFit.contain),
            ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
