// --- Data Models ---
// Represents an individual item/page within a category
class PageItem {
  final String id;
  final String title;
  final String content; // Example content for the item

  PageItem({required this.id, required this.title, required this.content});
}
