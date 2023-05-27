import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  late List<QueryDocumentSnapshot> _complaintDocs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getComplaintData();
  }

  Future<void> getComplaintData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('complaints');
    final userSnapshot = await userRef.where('userId', isEqualTo: userId).get();
    setState(() {
      _complaintDocs = userSnapshot.docs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _complaintDocs.length,
              itemBuilder: (context, index) {
                final doc = _complaintDocs[index];
                final data = doc.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(data['Item Code'] ?? 'Unknown'),
                    subtitle: Text('Description: ${data['Description'] ?? 'Unknown'}\n'
                        'Date: ${data['timestamp'].toDate() ?? 'Unknown'}\n'
                        'Status: ${data['Status'] ?? 'Unknown'}'),
                  ),
                );
              },
            ),
    );
  }
}
