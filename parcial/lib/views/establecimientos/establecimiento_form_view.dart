import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/establecimiento_model.dart';
import '../../services/establecimientos_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/logo_widget.dart';

class EstablecimientoFormView extends StatefulWidget {
  final EstablecimientoModel? model;

  const EstablecimientoFormView({super.key, this.model});

  @override
  State<EstablecimientoFormView> createState() => _EstablecimientoFormViewState();
}

class _EstablecimientoFormViewState extends State<EstablecimientoFormView> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _nombreCtrl;
  late TextEditingController _nitCtrl;
  late TextEditingController _direccionCtrl;
  late TextEditingController _telefonoCtrl;

  String? _logoLocalPath;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.model?.nombre ?? '');
    _nitCtrl = TextEditingController(text: widget.model?.nit ?? '');
    _direccionCtrl = TextEditingController(text: widget.model?.direccion ?? '');
    _telefonoCtrl = TextEditingController(text: widget.model?.telefono ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _nitCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoLocalPath = pickedFile.path;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final newModel = EstablecimientoModel(
      id: widget.model?.id,
      nombre: _nombreCtrl.text,
      nit: _nitCtrl.text,
      direccion: _direccionCtrl.text,
      telefono: _telefonoCtrl.text,
      logoUrl: widget.model?.logoUrl,
    );

    try {
      if (newModel.id == null) {
        await EstablecimientosService.instance.create(newModel, logoPath: _logoLocalPath);
      } else {
        await EstablecimientosService.instance.update(newModel, logoPath: _logoLocalPath);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado correctamente')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.model != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Establecimiento' : 'Nuevo Establecimiento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _buildLogoPreview(),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Seleccionar Logo'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nitCtrl,
                decoration: const InputDecoration(labelText: 'NIT', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _direccionCtrl,
                decoration: const InputDecoration(labelText: 'Dirección', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoCtrl,
                decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoPreview() {
    const size = 100.0;
    if (_logoLocalPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.file(
          File(_logoLocalPath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return LogoWidget(logoUrl: widget.model?.logoUrl, size: size);
  }
}
