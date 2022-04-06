import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/utils/utils.dart';

import '../providers/scan_list_provider.dart';

class ListScans extends StatelessWidget {
  final IconData icon;
  const ListScans({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final List<ScanModel>? scans = scanListProvider.scans;
    return ListView.builder(
      itemCount: scans!.length,
      itemBuilder: (_, index) => Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(scans[index].id.toString()),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction) {
          scanListProvider.deleteById(scans[index].id!);
        },
        child: ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[index].valor),
          subtitle: Text(scans[index].id.toString()),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () => {
            launchURL(context, scans[index])
            },
        ),
      ),
    );
  }
}
