import 'package:flutter/material.dart';
import 'package:learning_app/models/event.dart';
import 'package:learning_app/models/search_objects/event_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/event_provider.dart';
import 'package:learning_app/screens/event_details_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final EventProvider _eventProvider = EventProvider();
  SearchResult<Event> _eventResult = SearchResult<Event>();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final EventSearchObject _searchObject = EventSearchObject();
  final _borderRadius = BorderRadius.circular(20);

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
          _eventResult = data;
        } else {
          _eventResult.result.addAll(data.result);
          _eventResult.count = data.count;
        }
        _hasMore = data.result.length == _searchObject.pageSize;
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: "Events".toUpperCase(),
      settingsIcon: true,
      child: _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Events',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.deepPurple.shade300,
                        size: 35,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
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
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _loadEvents(reset: true),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          _eventResult.result.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _eventResult.result.length) {
                          return _hasMore
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }

                        final event = _eventResult.result[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: _borderRadius,
                            ),
                            elevation: 3,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: _borderRadius,
                              ),
                              tileColor: Colors.deepPurple.shade50,
                              title: Text(
                                event.eventName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    event.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailsScreen(event: event),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
