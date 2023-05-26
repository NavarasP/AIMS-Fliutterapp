import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AdminComplaintScreen extends StatefulWidget {
  const AdminComplaintScreen({Key? key}) : super(key: key);

  @override
  State<AdminComplaintScreen> createState() => _AdminComplaintScreenState();
}

class _AdminComplaintScreenState extends State<AdminComplaintScreen> {
  late List<QueryDocumentSnapshot> _newcomplaintDocs;
  late List<QueryDocumentSnapshot> _procomplaintDocs;
  late List<QueryDocumentSnapshot> _comcomplaintDocs;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    getComplaintData();
  }

  Future<void> getComplaintData() async {
    final compRef = FirebaseFirestore.instance.collection('complaints');
    final compSnapshotnew = await compRef.where('Status', isEqualTo: 'New').get();
    final compSnapshotpro = await compRef.where('Status', isEqualTo: 'Processing').get();
    final compSnapshotcom = await compRef.where('Status', isEqualTo: 'Completed').get();
    setState(() {
      _newcomplaintDocs = compSnapshotnew.docs;
      _procomplaintDocs = compSnapshotpro.docs;
      _comcomplaintDocs = compSnapshotcom.docs;
      _isLoading = false;
    });
  }
void _showComplaintDetailsnew(BuildContext context, Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['Item Code'] ?? 'Unknown'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${data['Description'] ?? 'Unknown'}'),
              SizedBox(height: 10),
              Text('Date: ${data['timestamp'].toDate() ?? 'Unknown'}'),
              SizedBox(height: 10),
              Text('Status: ${data['Status'] ?? 'Unknown'}'),
            ],
          ),
          actions: [
                        TextButton(
              onPressed: () async {
                // Update the status
                FirebaseFirestore.instance.collection('complaints').doc(docId).update({'Status': 'Processing'});
                Navigator.of(context).pop();
                 setState(() {
                _isLoading = true;
              });
              await getComplaintData();
            
              },
              child: Text('Mark as Processing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),


          ],
        );
      },
    );

  }

  void _showComplaintDetailspro(BuildContext context, Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['Item Code'] ?? 'Unknown'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${data['Description'] ?? 'Unknown'}'),
              SizedBox(height: 10),
              Text('Date: ${data['timestamp'].toDate() ?? 'Unknown'}'),
              SizedBox(height: 10),
              Text('Status: ${data['Status'] ?? 'Unknown'}'),
            ],
          ),
          actions: [
                        TextButton(
              onPressed: () async {
                // Update the status
                FirebaseFirestore.instance.collection('complaints').doc(docId).update({'Status': 'Completed'});
                Navigator.of(context).pop();
                setState(() {
                _isLoading = true;
              });
              await getComplaintData();
              },
              child: Text('Mark as Completed'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),


          ],
        );
      },
    );

  }
    void _showComplaintDetailscom(BuildContext context, Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['Item Code'] ?? 'Unknown'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${data['Description'] ?? 'Unknown'}'),
              SizedBox(height: 10),
              Text('Date: ${data['timestamp'].toDate() ?? 'Unknown'}'),
              SizedBox(height: 10),
              Text('Status: ${data['Status'] ?? 'Unknown'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),


          ],
        );
      },
    );

  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complaints'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'New'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  ListView.builder(
                    itemCount: _newcomplaintDocs.length,
                    itemBuilder: (context, index) {
                      final doc = _newcomplaintDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          _showComplaintDetailsnew(context, data, doc.id);
                        },
                        child:Card(
                        child: ListTile(
                          title: Text(data['Item Code'] ?? 'Unknown'),
                          subtitle: Text('Description: ${data['Description'] ?? 'Unknown'}\n'
                              'Date: ${data['timestamp'].toDate() ?? 'Unknown'}\n'
                              'Status: ${data['Status'] ?? 'Unknown'}'),
                        ),
                      ));
                    },
                  ),
                  ListView.builder(
                    itemCount: _procomplaintDocs.length,
                    itemBuilder: (context, index) {
                      final doc = _procomplaintDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          _showComplaintDetailspro(context, data, doc.id);
                        },
                        child:Card(
                        child: ListTile(
                          title: Text(data['Item Code'] ?? 'Unknown'),
                          subtitle: Text('Description: ${data['Description'] ?? 'Unknown'}\n'
                              'Date: ${data['timestamp'].toDate() ?? 'Unknown'}\n'
                              'Status: ${data['Status'] ?? 'Unknown'}'),
                        ),
                      ));
                    },
                  ),
                  ListView.builder(
                    itemCount: _comcomplaintDocs.length,
                    itemBuilder: (context, index) {
                      final doc = _comcomplaintDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return  GestureDetector(
                        onTap: () {
                          _showComplaintDetailscom(context, data, doc.id);
                        },
                      child:Card(
                        child: ListTile(
                         title: Text(data['Item Code'] ?? 'Unknown'),
                          subtitle: Text('Description: ${data['Description'] ?? 'Unknown'}\n'
                              'Date: ${data['timestamp'].toDate() ?? 'Unknown'}\n'
                              'Status: ${data['Status'] ?? 'Unknown'}'),
                         ),
                      ));
                    },
                  ),]))
    );
  }
}

