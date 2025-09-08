import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/event.dart';
import 'package:bringmehome_admin/models/search_objects/event_search_object.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/screens/edit_event.dart';
import 'package:bringmehome_admin/screens/event_add_screen.dart';
import 'package:bringmehome_admin/services/event_provider.dart';
import 'package:flutter/material.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  var borderRadius = BorderRadius.circular(20);
  final EventProvider _eventProvider = EventProvider();
  final ScrollController _scrollController = ScrollController();
  SearchResult<Event> _eventList = SearchResult<Event>();
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final EventSearchObject _searchObject = EventSearchObject();

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreEvents();
    }
  }

  Future<void> _loadEvents({bool reset = false}) async {
    if (reset) {
      _searchObject.pageNumber = 1;
      _hasMore = true;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _eventProvider.searchEvents(_searchObject);

      setState(() {
        if (reset) {
          _eventList = data;
        } else {
          _eventList.result.addAll(data.result);
          _eventList.count = data.count;
        }
        _hasMore = data.result.length == (_searchObject.pageSize);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load events: ${e.toString()}';
      });
    }
  }

  Future<void> _loadMoreEvents() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _searchObject.pageNumber = (_searchObject.pageNumber) + 1;
    });

    await _loadEvents();
  }

  void _handleSearch(String value) {
    _searchObject.fts = value.isNotEmpty ? value : null;
    _loadEvents(reset: true);
  }

  void _deleteEvent(int id) {
    _eventProvider.deleteEvent(id).then((_) {
      _loadEvents(reset: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
    }).catchError((error) {
      print('Error deleting event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: ${error.toString()}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreenWidget(
        backButton: true,
        titleText: 'EVENTS',
        child: _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                                color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Search',
                              labelStyle: const TextStyle(
                                  color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),

                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 35,
                              ),

                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.white),
                                      onPressed: () {
                                        _searchController.clear();
                                        _handleSearch('');
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: _handleSearch,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => const EventAddScreen(),
                                ),
                              )
                                  .then((result) {
                                if (result == true) {
                                  _loadEvents(reset: true);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 142, 205, 117),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: _eventList.result.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _eventList.result.length && _hasMore) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final event = _eventList.result[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: borderRadius),
                            tileColor: const Color.fromRGBO(255, 255, 255, 1),
                            title: Text(
                              event.eventName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(149, 117, 205, 1),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shelter: ${event.shelterName ?? 'Unknown'}',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(154, 126, 202, 1),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${event.eventDate.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(82, 59, 121, 1)),
                                ),
                                Text(
                                  'Location: ${event.location}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(82, 59, 121, 1)),
                                ),
                                Text(
                                  'Description: ${event.description}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(82, 59, 121, 1)),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EventEditScreen(event: event),
                                      ),
                                    )
                                        .then((result) {
                                      if (result == true) {
                                        _loadEvents(reset: true);
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromRGBO(149, 117, 205, 1),
                                    size: 20,
                                  ),
                                  tooltip: 'Edit Event',
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 205, 117, 117),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to delete this event?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 205, 117, 117),
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteEvent(event.eventID);
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    tooltip: 'Delete Event',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
