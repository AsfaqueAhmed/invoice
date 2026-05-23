import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/customer_add_controller.dart';

class CustomerAddView extends GetView<CustomerAddController> {
  const CustomerAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return AddCustomerScreen();
  }
}

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller definitions
  final _nameController = TextEditingController();
  final _businessController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  String? _selectedAvatarUrl;
  bool _isSaving = false;
  bool _isSavedSuccess = false;

  // Mock list of user photos to cycle through on upload click
  final List<String> _mockImages = [
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=200'
  ];

  void _simulatePhotoUpload() {
    setState(() {
      final random = math.Random();
      _selectedAvatarUrl = _mockImages[random.nextInt(_mockImages.length)];
    });
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate network save request duration
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isSaving = false;
      _isSavedSuccess = true;
    });

    // Display clean Toast/Snackbar visual notification feedback system
    _showSuccessToast();

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isSavedSuccess = false;
      });
    }
  }

  void _showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E3039),
        // inverse-surface
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.12,
          left: 24,
          right: 24,
        ),
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Color(0xFFB4C5FF)),
            SizedBox(width: 12),
            Text(
              "Customer added successfully",
              style: TextStyle(
                  color: Color(0xFFF0F0FB), fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideLayout = screenWidth > 640;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),

      // --- Top App Bar ---
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FF),
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF434655)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'InvoiceFlow',
          style: TextStyle(
              color: Color(0xFF0044AC6),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          if (isWideLayout)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                'ADD CUSTOMER',
                style: TextStyle(
                    color: Color(0xFF434655),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Image.network(
                'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=100&q=80',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),

      // --- Fixed Bottom Action Bar for Mobile Viewports ---
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: const Color(0xFFC3C6D7).withOpacity(0.4))),
            ),
            child: SafeArea(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSavedSuccess
                          ? const Color(0xFFBC4800)
                          : const Color(0xFF0044AC6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                    child: _buildButtonChild(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // --- Form Main Body Body Content ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600), // max-w-2xl
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('New Customer',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191B23))),
                  const SizedBox(height: 4),
                  const Text('Create a professional profile for your client.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF434655))),
                  const SizedBox(height: 24),

                  // 1. Photo Upload Card Group Container
                  _buildCardSection(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _simulatePhotoUpload,
                          child: Stack(
                            children: [
                              CustomPaint(
                                painter: _DashedCirclePainter(
                                  color: _selectedAvatarUrl != null
                                      ? const Color(0xFF0044AC6)
                                      : const Color(0xFFC3C6D7),
                                  isSolid: _selectedAvatarUrl != null,
                                ),
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  alignment: Alignment.center,
                                  child: _selectedAvatarUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(99),
                                          child: Image.network(
                                              _selectedAvatarUrl!,
                                              width: 92,
                                              height: 92,
                                              fit: BoxFit.cover),
                                        )
                                      : const Icon(Icons.add_a_photo_outlined,
                                          size: 32, color: Color(0xFF505F76)),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0044AC6),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit,
                                      size: 12, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Select profile photo',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF434655))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Basic Information Card Group Container
                  _buildCardSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BASIC DETAILS',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0044AC6),
                                letterSpacing: 1.5)),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Full Name *',
                          hint: 'John Doe',
                          icon: Icons.person_outline,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter full name profile metadata';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Business Name (Optional)',
                          hint: 'Acme Corp',
                          icon: Icons.business_outlined,
                          controller: _businessController,
                        ),
                        const SizedBox(height: 16),
                        _buildResponsiveRow(
                          isWide: isWideLayout,
                          child1: _buildInputField(
                            label: 'Email Address',
                            hint: 'john@example.com',
                            icon: Icons.mail_outline,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          child2: _buildInputField(
                            label: 'Phone Number',
                            hint: '+1 (555) 000-0000',
                            icon: Icons.call_outlined,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Address Information Card Group Container
                  _buildCardSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ADDRESS DETAILS',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0044AC6),
                                letterSpacing: 1.5)),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Street Address',
                          hint: '123 Financial Way',
                          icon: Icons.location_on_outlined,
                          controller: _addressController,
                        ),
                        const SizedBox(height: 16),
                        _buildResponsiveRow(
                          isWide: isWideLayout,
                          child1: _buildInputField(
                            label: 'City',
                            hint: 'New York',
                            controller: _cityController,
                          ),
                          child2: _buildInputField(
                            label: 'State / Province',
                            hint: 'NY',
                            controller: _stateController,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Postal Code',
                          hint: '10001',
                          icon: Icons.mark_as_unread_outlined,
                          controller: _zipController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Custom Builder Layout: Card Layout Wrappers
  Widget _buildCardSection({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 25,
              offset: const Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }

  // Helper Custom Builder Layout: Modular Input Configuration Block
  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF434655),
                  fontWeight: FontWeight.w500)),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 16, color: Color(0xFF191B23)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF737686), fontSize: 16),
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFF434655), size: 22)
                : null,
            filled: true,
            fillColor: const Color(0xFFF3F3FE),
            // surface-container-low
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFBA1A1A), width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Custom Builder Layout: Responsive Structural Alignment Controller
  Widget _buildResponsiveRow(
      {required bool isWide, required Widget child1, required Widget child2}) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: child1),
          const SizedBox(width: 16),
          Expanded(child: child2),
        ],
      );
    }
    return Column(
      children: [
        child1,
        const SizedBox(height: 16),
        child2,
      ],
    );
  }

  // Dynamic Widget Helper: Swaps bottom bar internals accurately based on interactive state metrics
  Widget _buildButtonChild() {
    if (_isSaving) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white)),
          SizedBox(width: 12),
          Text('Saving...',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      );
    }
    if (_isSavedSuccess) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 8),
          Text('Saved',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      );
    }
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.save, color: Colors.white),
        SizedBox(width: 8),
        Text('Save Customer',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Custom Painter: Renders the precise circular dashed outline boundary loop frame cleanly
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final bool isSolid;

  _DashedCirclePainter({required this.color, required this.isSolid});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 2) / 2;

    if (isSolid) {
      canvas.drawCircle(center, radius, paint);
    } else {
      const int dashCount = 16;
      const double dashLength = 0.22;
      const double spaceLength = 0.17;

      for (int i = 0; i < dashCount; i++) {
        double startAngle = i * (dashLength + spaceLength);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          dashLength,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
