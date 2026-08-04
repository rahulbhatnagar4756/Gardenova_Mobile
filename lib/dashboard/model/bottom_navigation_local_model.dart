import '../components/bottom_navigation_widget.dart';

class BottomNavigationLocalModel {
  final BottomNavType type;
  final String label;
  final String icon;
  bool isCenterIcon;
  BottomNavigationLocalModel({
    required this.type,
    required this.label,
    required this.icon,
    this.isCenterIcon = false,
  });
}
