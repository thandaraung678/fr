import 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/create_custodain_model.dart';
import 'custodian_form.dart';

class CustodianTable extends StatefulWidget {
  final List<Custodian> custodians;
  final Function(Custodian) onAdd;
  final Function(Custodian) onUpdate;
  final Function(int) onDelete;

  const CustodianTable({
    super.key,
    required this.custodians,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<CustodianTable> createState() => _CustodianTableState();
}

class _CustodianTableState extends State<CustodianTable> {
  void openForm({Custodian? custodian}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustodianForm(
          custodian: custodian,
          onSubmit: custodian == null
              ? widget.onAdd
              : widget.onUpdate,
        ),
      ),
    );
  }

  void deleteCustodian(Custodian custodian) {
    if (custodian.custodianId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete: Custodian ID is missing'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Custodian'),
        content: Text(
          'Delete ${custodian.custodianName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              widget.onDelete(custodian.custodianId!);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custodian Management'),
        actions: [
          IconButton(
            onPressed: () => openForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Add Custodian',
          ),
        ],
      ),
      body: widget.custodians.isEmpty
          ? const Center(child: Text('No custodians found'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Branch ID')),
                    DataColumn(label: Text('Dept ID')),
                    DataColumn(label: Text('Code')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Hold Assets')),
                    DataColumn(label: Text('Active')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: widget.custodians.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${c.custodianId ?? '-'}')),
                        DataCell(Text('${c.branchId ?? '-'}')),
                        DataCell(Text('${c.deptId ?? '-'}')),
                        DataCell(Text(c.custodianCode ?? '-')),
                        DataCell(Text(c.custodianName)),
                        DataCell(Text(c.custodianType)),
                        DataCell(Text(c.phone ?? '-')),
                        DataCell(Text(c.email ?? '-')),
                        DataCell(
                          Icon(
                            c.canHoldAssets
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: c.canHoldAssets
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        DataCell(
                          Icon(
                            c.isActive
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: c.isActive
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Edit',
                                onPressed: () =>
                                    openForm(custodian: c),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip: 'Delete',
                                onPressed: () => deleteCustodian(c),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}