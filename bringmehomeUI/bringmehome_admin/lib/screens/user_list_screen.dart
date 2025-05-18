import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/models/user.dart';
import 'package:bringmehome_admin/screens/add_new_user.dart';
import 'package:bringmehome_admin/screens/edit_user.dart';
import 'package:bringmehome_admin/services/user_provider.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserProvider _userProvider = UserProvider();
  final SearchResult<User> _userResult = SearchResult<User>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAdopters();
  }

  Future<void> _loadAdopters() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _userProvider.getAdopters();

      setState(() {
        _userResult.result = data;
        _userResult.count = data.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load adopters: ${e.toString()}';
      });
    }
  }

  void _deleteUser(int id) {
    _userProvider.deleteUser(id).then((_) {
      _loadAdopters();
    }).catchError((error) {
      print('Error deleting user: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: 'USER LIST',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 16.0),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add New User'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewUserScreen(),
                      ),
                    ).then((_) {
                      _loadAdopters();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            Expanded(
              child: _userResult.result.isEmpty && !_isLoading
                  ? const Center(child: Text('No users found.'))
                  : ListView.builder(
                      itemCount:
                          _userResult.result.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _userResult.result.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final user = _userResult.result[index];
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
                                    '${user.firstName} ${user.lastName}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    user.phoneNumber ?? 'No phone number',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    user.address ?? 'No address',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditUserScreen(
                                              user: user,
                                            ),
                                          ),
                                        ).then((_) {
                                          _loadAdopters();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      tooltip: 'Edit User',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text('Confirm Deletion'),
                                            content: Text(
                                                'Are you sure you want to delete ${user.firstName} ${user.lastName}?'),
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
                                                  _deleteUser(user.id!);
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
                                      tooltip: 'Delete User',
                                    ),
                                  ],
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
