import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import '../onboarding/language_select.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void verifyOtp() async {
    focusNode.unfocus();

    if (pinController.text.length != 6) {
      setState(() {
        errorMessage = 'Please enter the complete 6-digit OTP';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: pinController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to onboarding after successful login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LanguageSelectionScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Invalid OTP. Please try again.';
      });
    }
  }

  void resendOtp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
            errorMessage = e.message ?? 'Verification failed';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading = false;
          });
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP resent successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to resend OTP. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.green,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.green.shade700),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade700),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verify Phone'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.green.shade700,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade700.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security,
                  size: 72,
                  color: Colors.green.shade700,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Enter Verification Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),

              const SizedBox(height: 12),

              // Phone Number
              Text(
                'We sent a 6-digit code to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              Text(
                widget.phoneNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),

              const SizedBox(height: 48),

              // OTP Input
              Pinput(
                length: 6,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return 'Please enter 6-digit OTP';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (errorMessage != null) {
                    setState(() {
                      errorMessage = null;
                    });
                  }
                },
                onCompleted: (value) {
                  verifyOtp();
                },
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 32),

              // Verify Button
              ElevatedButton(
                onPressed: isLoading ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Verify & Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  TextButton(
                    onPressed: isLoading ? null : resendOtp,
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              // Help Text
              const Spacer(),
              Text(
                'By verifying, you agree to receive SMS for authentication',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
