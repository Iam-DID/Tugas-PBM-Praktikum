import 'package:flutter/material.dart';
import 'api.dart';

class SubmitTugasScreen extends StatefulWidget {
  const SubmitTugasScreen({super.key});

  @override
  State<SubmitTugasScreen> createState() => _SubmitTugasScreenState();
}

class _SubmitTugasScreenState extends State<SubmitTugasScreen> {
  String _name = '';
  String _price = '';
  String _description = '';
  String _githubUrl = '';
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _submitData() async {
    if (_name.isEmpty || _price.isEmpty || _githubUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, Harga, dan Link GitHub wajib diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    bool success = await _apiService.submitTugas(
      _name,
      int.tryParse(_price) ?? 0,
      _description,
      _githubUrl,
    );
    
    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tugas berhasil dikumpulkan!'),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal mengumpulkan tugas!'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Pengumpulan Tugas', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            _buildTextField(
              label: "Nama Tugas", 
              icon: Icons.label_important_outline,
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Harga", 
              icon: Icons.payments_outlined, 
              isNumber: true,
              onChanged: (value) => _price = value,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Deskripsi", 
              icon: Icons.description_outlined, 
              maxLines: 3,
              onChanged: (value) => _description = value,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Link GitHub (URL)", 
              icon: Icons.link, 
              onChanged: (value) => _githubUrl = value,
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: _isLoading ? null : _submitData,
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('KUMPULKAN TUGAS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required IconData icon, 
    required Function(String) onChanged,
    bool isNumber = false, 
    int maxLines = 1,
  }) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.green.shade400, width: 2)),
      ),
    );
  }
}