import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/FeeStructureController.dart';
import '../../models/fee_stucture.dart';

class FeeStructureScreen extends StatelessWidget {
  FeeStructureScreen({super.key});

  final FeeStructureController _controller = Get.put(FeeStructureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Structure Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFeeDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildFeeStructuresList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _controller.currentFilter.value,
              items: ['All', 'Tuition', 'Exam', 'Transport', 'Other'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                _controller.currentFilter.value = value!;
                _controller.fetchFeeStructures(
                  feeTypeFilter: value == 'All' ? null : value,
                );
              },
              decoration: const InputDecoration(
                labelText: 'Filter by Type',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeStructuresList() {
    if (_controller.feeStructures.isEmpty) {
      return const Center(child: Text('No fee structures found'));
    }

    return ListView.builder(
      itemCount: _controller.feeStructures.length,
      itemBuilder: (context, index) {
        final fee = _controller.feeStructures[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(fee.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fee.description),
                Text('Amount: ${fee.amount} PKR'),
                Text('Due: ${fee.formattedDueDate}'),
                Text('Classes: ${fee.applicableClasses.join(', ')}'),
                Text('Type: ${fee.feeType}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    fee.isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: fee.isActive ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => _controller.toggleStatus(fee.id, fee.isActive),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddFeeDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final amountController = TextEditingController();
    DateTime? dueDate;
    String feeType = 'Tuition';
    final classController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Fee Structure'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Fee Name'),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount (PKR)'),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  ListTile(
                    title: Text(dueDate == null
                        ? 'Select Due Date'
                        : 'Due Date: ${DateFormat('dd/MM/yyyy').format(dueDate!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      if (date != null) dueDate = date;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: feeType,
                    items: ['Tuition', 'Exam', 'Transport', 'Other'].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) => feeType = value!,
                    decoration: const InputDecoration(labelText: 'Fee Type'),
                  ),
                  TextFormField(
                    controller: classController,
                    decoration: const InputDecoration(
                      labelText: 'Applicable Classes (comma separated)',
                      hintText: 'e.g., Class 1, Class 2, Class 3',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate() && dueDate != null) {
                  final classes = classController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  if (classes.isEmpty) {
                    Get.snackbar('Error', 'Please enter at least one class');
                    return;
                  }

                  final newFee = FeeStructure(
                    id: '', // Will be generated by Firestore
                    name: nameController.text,
                    description: descController.text,
                    amount: double.parse(amountController.text),
                    dueDate: dueDate!,
                    applicableClasses: classes,
                    feeType: feeType,
                    academicYear: null, // You can add academic year logic here if needed
                  );

                  await _controller.addFeeStructure(newFee);
                  Navigator.pop(context);
                } else if (dueDate == null) {
                  Get.snackbar('Error', 'Please select a due date');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}