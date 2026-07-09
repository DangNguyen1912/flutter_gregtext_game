import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/models/items/item.dart';
import 'package:flutter_gregtext_game/models/user/game_user.dart';
import 'package:flutter_gregtext_game/services/database_service.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  GameUser? _user;
  bool _isLoading = true;
  String _searchQuery = '';
  // TODO: turn List string to List item type enum
  // TODO: _filterOptions remove and add correct options
  final List<String> _selectedFilter = [];
  final List<String> _filterOptions = ['a', 'aa', 'aaa', 'b', 'bb'];
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final user = await db.getUser();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _refreshInventory() async {
    setState(() => _isLoading = true);
    await _loadUser();
  }

  List<Item> _getFilteredItems() {
    if (_user == null) return [];
    var inventory = _user!.inventory.inventory;

    // filter by name
    if (_searchQuery.isNotEmpty) {
      inventory = inventory
          .where(
            (item) => item.itemName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
    if (_selectedFilter.isNotEmpty) {
      inventory = inventory
          .where((item) => _selectedFilter.contains(item.iventoryType))
          .toList();
    }
    inventory.sort((a, b) {
      int typeComparison = a.iventoryType.compareTo(b.iventoryType);
      if (typeComparison != 0) {
        return typeComparison;
      }
      return a.itemName.compareTo(b.itemName);
    });
    return inventory;
  }

  @override
  Widget build(BuildContext context) {
    List<Item> filteredItems = _user != null ? _getFilteredItems() : [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshInventory,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 8),
                // Filter Chips
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterOptions.length + 1,
                    itemBuilder: (context, index) {
                      if (index > 0) {
                        // TODO: filters are shown as image,
                        // TODO: turn item type from strings to enum, facto item model also
                        final filter = _filterOptions[index - 1];
                        final isSelected = _selectedFilter.contains(filter);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            showCheckmark: false,
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selected
                                    ? _selectedFilter.add(filter)
                                    : _selectedFilter.remove(filter);
                              });
                            },
                            backgroundColor: Colors.grey[900],
                            selectedColor: Colors.grey[700],
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Filter:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 8),
                const Divider(height: 1),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),

      body: _user == null || _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator(), Text("Loading...")],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: filteredItems.elementAtOrNull(index) != null
                      ? [
                          // TODO: show item as small image with count number bottom right and type top right
                          Text('name: ${filteredItems[index].itemName}'),
                          Text('count: ${filteredItems[index].count}'),
                          Text('type: ${filteredItems[index].iventoryType}'),
                        ]
                      : [
                          // TODO: if not filtered, show all items and empty slots
                        ],
                ),
              ),
            ),
      // : Column(
      //     children: [
      //       Text('${filteredItems.length}'),
      //       Text(_user != null ? _user!.userId : 'null '),
      //     ],
      //   ),
    );
  }
}
