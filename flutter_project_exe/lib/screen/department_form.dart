
import 'package:flutter/material.dart';
import 'package:flutter_project_exe/model/create_department_model.dart';

class DepartmentForm extends StatefulWidget {
  final Department? department;
  final Function(Department) onSubmit;

  const DepartmentForm({
    super.key,
    this.department,
    required this.onSubmit,
  });

  @override
  State<DepartmentForm> createState() => _DepartmentFormState();
}

class _DepartmentFormState extends State<DepartmentForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _parentController;
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _shortNameController;

  String _deptType = 'OPERATIONS';
  bool _allowAssignment = true;
  bool _isActive = true;

  final List<String> _deptTypes = [
    'HR',
    'IT',
    'FINANCE',
    'SALES',
    'MARKETING',
    'OPERATIONS',
  ];

  @override
  void initState() {
    super.initState();

    final d = widget.department;

    _parentController = TextEditingController(
      text: d?.parentDeptId?.toString() ?? '',
    );
    _codeController =
        TextEditingController(text: d?.deptCode ?? '');
    _nameController =
        TextEditingController(text: d?.deptName ?? '');
    _shortNameController =
        TextEditingController(text: d?.deptShortName ?? '');

    _deptType = d?.deptType ?? 'OPERATIONS';
    _allowAssignment = d?.allowAssignment ?? true;
    _isActive = d?.isActive ?? true;
  }

  @override
  void dispose() {
    _parentController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final parentText = _parentController.text.trim();
    final parentId =
        parentText.isEmpty ? null : int.tryParse(parentText);

    if (parentText.isNotEmpty && parentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parent Department ID must be a number'),
        ),
      );
      return;
    }

    final department = Department(
      departmentId: widget.department?.departmentId,
      parentDeptId: parentId,
      deptCode: _codeController.text.trim().isEmpty
          ? null
          : _codeController.text.trim(),
      deptName: _nameController.text.trim(),
      deptShortName: _shortNameController.text.trim(),
      deptType: _deptType,
      allowAssignment: _allowAssignment,
      isActive: _isActive,
    );

    widget.onSubmit(department);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.department == null
              ? 'Add Department'
              : 'Edit Department',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _parentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Parent Department ID (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Department Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Department name is required'
                      : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _shortNameController,
              decoration: const InputDecoration(
                labelText: 'Department Short Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Short name is required'
                      : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _deptType,
              decoration: const InputDecoration(
                labelText: 'Department Type',
                border: OutlineInputBorder(),
              ),
              items: _deptTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _deptType = value);
                }
              },
            ),
            SwitchListTile(
              title: const Text('Allow Assignment'),
              value: _allowAssignment,
              onChanged: (value) =>
                  setState(() => _allowAssignment = value),
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (value) =>
                  setState(() => _isActive = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save Department'),
            ),
          ],
        ),
      ),
    );
  }
}
