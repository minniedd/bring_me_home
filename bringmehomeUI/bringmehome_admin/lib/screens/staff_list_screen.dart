import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/screens/add_new_staff.dart';
import 'package:bringmehome_admin/screens/edit_staff_screen.dart';
import 'package:bringmehome_admin/services/staff_provider.dart';
import 'package:flutter/material.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final StaffProvider _staffProvider = StaffProvider();
  Future<List<Staff>> _staffFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadStaffMembers();
  }

  void _loadStaffMembers() {
    setState(() {
      _staffFuture = _staffProvider.getStaff();
    });
  }

  void _deleteStaffMember(int id) {
    _staffProvider.deleteStaff(id).then((_) {
      _loadStaffMembers();
    }).catchError((error) {
      print('Error deleting staff member: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: 'STAFF LIST',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                child: const Text('Add New Staff'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewStaffScreen(),
                    ),
                  ).then((_) {
                    _loadStaffMembers();
                  });
                },
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<List<Staff>>(
                future: _staffFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No staff members found.'));
                  } else {
                    final staffMembers = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: staffMembers.length,
                      itemBuilder: (context, index) {
                        final staffMember = staffMembers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${staffMember.user?.firstName} ${staffMember.user?.lastName}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    staffMember.user!.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    staffMember.user?.phoneNumber ??
                                        'No phone number',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    staffMember.user?.address ?? 'No address',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    staffMember.position,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditStaffScreen(
                                                    staff: staffMember),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadStaffMembers();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      tooltip: 'Edit Staff',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text('Confirm Deletion'),
                                            content: Text(
                                                'Are you sure you want to delete ${staffMember.user?.firstName} ${staffMember.user?.lastName}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteStaffMember(
                                                      staffMember.staffID);
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      tooltip: 'Delete Staff',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
