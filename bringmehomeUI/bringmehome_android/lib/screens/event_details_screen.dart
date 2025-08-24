import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/models/event.dart';
import 'package:learning_app/widgets/master_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final _dateFormat = DateFormat('MMMM d, yyyy');
  final _timeFormat = DateFormat('h:mm a');
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MasterScreenWidget(
      titleText: 'EVENT DETAILS',
      settingsIcon: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.eventName,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (event.shelterName != null)
                          Text(
                            'Hosted by: ${event.shelterName!}',
                            style: textTheme.bodyLarge,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.calendar_today,
                            title: 'Date',
                            value: _dateFormat.format(event.eventDate),
                            theme: theme,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            icon: Icons.access_time,
                            title: 'Time',
                            value: _timeFormat.format(event.eventDate),
                            theme: theme,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            icon: Icons.location_on,
                            title: 'Location',
                            value: event.location,
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'About this event',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: theme.primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
