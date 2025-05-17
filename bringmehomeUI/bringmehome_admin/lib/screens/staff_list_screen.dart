import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/screens/add_new_staff.dart';
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${staffMember.user!.firstName} ${staffMember.user!.lastName}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  staffMember.user?.email ?? 'No email',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  staffMember.user?.phoneNumber ??
                                      'No phone number',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  staffMember.user?.address ?? 'No address',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  staffMember.position,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                  onPressed: () {
                                    _deleteStaffMember(staffMember.staffID);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteStaffMember(staffMember.staffID);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                                  ],
                                )
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
