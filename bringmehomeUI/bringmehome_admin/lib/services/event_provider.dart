import 'package:bringmehome_admin/models/event.dart';
import 'package:bringmehome_admin/models/search_objects/event_search_object.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class EventProvider extends BaseProvider<Event> {
  EventProvider() : super("api/Event");

  @override
  Event fromJson(data) {
    return Event.fromJson(data);
  }

  Future<SearchResult<Event>> searchEvents(EventSearchObject searchObject) async {
    return await get(filter: searchObject);
  }

  Future<Event> addEvent(dynamic request) async {
    return await super.insert(request);
  }

  Future<Event> updateEvent(int id, dynamic request) async {
    return await super.update(id, request);
  }

  Future<bool> deleteEvent(int id) async {
    return await super.delete(id);
  }
}