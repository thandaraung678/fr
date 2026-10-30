
import 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/create_department_model.dart';
class DepartmentTable extends StatelessWidget {
  final List<Department> departments;
  final VoidCallback onAdd;
  final Function(Department) onUpdate;
  final Function(Department) onDelete;

  const DepartmentTable({
    super.key,
    required this.departments,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Management'),
      ),
      body: departments.isEmpty
          ? const Center(child: Text('No departments found'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Parent ID')),
                    DataColumn(label: Text('Code')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Short Name')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Assignment')),
                    DataColumn(label: Text('Active')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: departments.map((d) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${d.departmentId ?? '-'}')),
                        DataCell(Text('${d.parentDeptId ?? '-'}')),
                        DataCell(Text(d.deptCode ?? '-')),
                        DataCell(Text(d.deptName)),
                        DataCell(Text(d.deptShortName)),
                        DataCell(Text(d.deptType)),
                        DataCell(Text(
                            d.allowAssignment ? 'Yes' : 'No')),
                        DataCell(Text(d.isActive ? 'Yes' : 'No')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => onUpdate(d),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirm =
                                      await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                          'Delete Department?'),
                                      content: Text(
                                        'Delete ${d.deptName}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    onDelete(d);
                                  }
                                },
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
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
