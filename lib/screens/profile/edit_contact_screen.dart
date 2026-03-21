import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/emergency_contact.dart';

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({super.key, this.contactId});

  final String? contactId;

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _phoneController;
  late final TextEditingController _relationshipController;
  bool _initialized = false;
  int _priority = 1;
  bool _isPrimary = false;
  bool _supportsMessaging = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _roleController = TextEditingController();
    _phoneController = TextEditingController();
    _relationshipController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    final existing = AppStateScope.of(context).contactById(widget.contactId);
    _nameController.text = existing?.name ?? '';
    _roleController.text = existing?.role ?? '';
    _phoneController.text = existing?.phone ?? '';
    _relationshipController.text = existing?.relationship ?? '';
    _priority = existing?.priority ?? 1;
    _isPrimary = existing?.isPrimary ?? false;
    _supportsMessaging = existing?.supportsMessaging ?? true;
    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _save() {
    final appState = AppStateScope.of(context);
    final contact = EmergencyContact(
      id: widget.contactId ?? 'contact-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim().isEmpty
          ? 'New contact'
          : _nameController.text.trim(),
      role: _roleController.text.trim().isEmpty
          ? 'Emergency contact'
          : _roleController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? '+1 404 555 0100'
          : _phoneController.text.trim(),
      relationship: _relationshipController.text.trim().isEmpty
          ? 'Family'
          : _relationshipController.text.trim(),
      priority: _priority,
      isPrimary: _isPrimary,
      supportsMessaging: _supportsMessaging,
    );

    appState.saveContact(contact);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.contactId != null;
    final ui = context.qatUi;

    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit contact' : 'Add contact')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            ui.screenHorizontalPadding,
            12,
            ui.screenHorizontalPadding,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ui.accessibilityMode) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(ui.cardPadding),
                    child: Text(
                      'Keep this simple. Add one name, one phone number, and the right priority.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _relationshipController,
                decoration: const InputDecoration(labelText: 'Relationship'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone number'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<int>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 · First')),
                  DropdownMenuItem(value: 2, child: Text('2 · Second')),
                  DropdownMenuItem(value: 3, child: Text('3 · Third')),
                  DropdownMenuItem(value: 4, child: Text('4 · Fourth')),
                ],
                onChanged: (value) => setState(() => _priority = value ?? 1),
              ),
              const SizedBox(height: 14),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Primary contact'),
                subtitle: const Text(
                  'Highlight this contact at the top of the list.',
                ),
                value: _isPrimary,
                onChanged: (value) => setState(() => _isPrimary = value),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Supports messaging'),
                subtitle: const Text(
                  'Show message as a quick action alongside calling.',
                ),
                value: _supportsMessaging,
                onChanged: (value) => setState(() => _supportsMessaging = value),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(editing ? 'Save changes' : 'Add contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
