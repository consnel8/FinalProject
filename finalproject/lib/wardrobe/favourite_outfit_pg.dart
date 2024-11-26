import 'package:flutter/material.dart';import 'package:flutter/material.dart';

class FavoriteOutfitsPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteOutfits;

  FavoriteOutfitsPage({required this.favoriteOutfits});

  @override
  _FavoriteOutfitsPageState createState() => _FavoriteOutfitsPageState();
}

class _FavoriteOutfitsPageState extends State<FavoriteOutfitsPage> {
  bool isGridView = false;
  String sortOption = 'Date Liked';
  String filterOption = 'All';

  void sortFavorites() {
    setState(() {
      if (sortOption == 'Date Liked') {
        widget.favoriteOutfits.sort((a, b) => b['dateLiked'].compareTo(a['dateLiked']));
      } else if (sortOption == 'Ascending') {
        widget.favoriteOutfits.sort((a, b) => a['title'].compareTo(b['title']));
      } else if (sortOption == 'Descending') {
        widget.favoriteOutfits.sort((a, b) => b['title'].compareTo(a['title']));
      }
    });
  }

  void filterFavorites() {
    setState(() {
      if (filterOption != 'All') {
        widget.favoriteOutfits.retainWhere((outfit) => outfit['type'] == filterOption);
      }
    });
  }

  void onDeleteOutfit(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Outfit'),
        content: Text('Are you sure you want to delete this outfit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.favoriteOutfits.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void onUnlikeOutfit(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove from Favorites'),
        content: Text('Are you sure you want to unlike this outfit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.favoriteOutfits[index]['isFavorite'] = false;
              });
              Navigator.pop(context);
            },
            child: Text('Unlike'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Outfits'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                if (value == 'Sort') {
                  sortFavorites();
                } else {
                  filterOption = value;
                  filterFavorites();
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Sort', child: Text('Sort by Date Liked')),
              PopupMenuItem(value: 'Ascending', child: Text('Sort Ascending')),
              PopupMenuItem(value: 'Descending', child: Text('Sort Descending')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'All', child: Text('Filter: All')),
              PopupMenuItem(value: 'Clothing', child: Text('Filter: Clothing')),
              PopupMenuItem(value: 'Accessories', child: Text('Filter: Accessories')),
            ],
          ),
        ],
      ),
      body: isGridView
          ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: widget.favoriteOutfits.length,
        itemBuilder: (context, index) {
          final outfit = widget.favoriteOutfits[index];
          return buildOutfitTile(outfit, index);
        },
      )
          : ListView.builder(
        itemCount: widget.favoriteOutfits.length,
        itemBuilder: (context, index) {
          final outfit = widget.favoriteOutfits[index];
          return buildOutfitTile(outfit, index);
        },
      ),
    );
  }

  Widget buildOutfitTile(Map<String, dynamic> outfit, int index) {
    return Dismissible(
      key: ValueKey(outfit['id']),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.orange,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
        child: Icon(Icons.remove_circle, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onDeleteOutfit(index);
          return false;
        } else {
          onUnlikeOutfit(index);
          return false;
        }
      },
      child: Card(
        child: isGridView
            ? Column(
          children: [
            Image.network(outfit['image'], height: 100, fit: BoxFit.cover),
            Text(outfit['title']),
          ],
        )
            : Row(
          children: [
            Image.network(outfit['image'], width: 100, fit: BoxFit.cover),
            Expanded(child: Text(outfit['title'])),
          ],
        ),
      ),
    );
  }
}
