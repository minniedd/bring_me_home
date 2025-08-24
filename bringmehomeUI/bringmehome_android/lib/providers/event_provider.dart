import 'package:learning_app/models/event.dart';
import 'package:learning_app/models/search_objects/event_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/base_provider.dart';

class EventProvider extends BaseProvider<Event> {
  EventProvider() : super("api/Event");

  @override
  Event fromJson(data) {
    return Event.fromJson(data);
  }

  Future<SearchResult<Event>> searchEvents(EventSearchObject searchObject) async {
    return await get(filter: searchObject);
  }
}