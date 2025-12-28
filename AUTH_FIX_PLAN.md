# Authentication Fix Plan - Agri Platform

## 🎯 Objectives
1. Fix broken authentication flow
2. Integrate AuthWrapper into main app
3. Ensure login page is reached first
4. Make OTP verification functional
5. Connect Firebase properly
6. Standardize routing

## 📋 Step-by-Step Implementation

### Step 1: Update Main App Structure
- [ ] Fix main.dart to use AuthWrapper as root
- [ ] Ensure proper Firebase initialization
- [ ] Update routing to support auth checking

### Step 2: Fix Authentication Flow
- [ ] Update AuthWrapper to handle routing properly
- [ ] Connect login screen to onboarding flow
- [ ] Fix OTP verification integration
- [ ] Handle authentication state properly

### Step 3: Update Onboarding Integration
- [ ] Modify splash screen to check auth first
- [ ] Ensure proper navigation after login
- [ ] Fix profile screen to redirect to home after auth

### Step 4: Firebase Integration
- [ ] Verify Firebase project configuration
- [ ] Test phone authentication setup
- [ ] Ensure proper error handling

### Step 5: Backend Connectivity
- [ ] Verify backend is running
- [ ] Test API endpoints
- [ ] Fix any connection issues

### Step 6: Testing & Validation
- [ ] Test complete authentication flow
- [ ] Verify no auth bypasses exist
- [ ] Test all routing scenarios

## 🔧 Technical Changes Required

### Main.dart Changes
```dart
// Replace direct routes with AuthWrapper
class AgriBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(), // This is the key change
      // ... rest of config
    );
  }
}
```

### AuthWrapper Updates
```dart
// Handle authenticated vs unauthenticated routing
StreamBuilder<User?> {
  if (snapshot.hasData) {
    return HomeDashboardScreen(); // Or continue to onboarding if profile incomplete
  }
  return LoginScreen(); // Force login
}
```

### Splash Screen Integration
```dart
// Check auth status before proceeding
Timer(Duration(seconds: 2), () {
  if (FirebaseAuth.instance.currentUser != null) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  } else {
    Navigator.pushReplacementNamed(context, AppRoutes.language);
  }
});
```

## ✅ Success Criteria
- [ ] Login screen appears first for new users
- [ ] OTP verification works end-to-end
- [ ] Authenticated users can access app features
- [ ] Unauthenticated users cannot bypass login
- [ ] Firebase auth status is properly tracked
- [ ] Backend APIs are accessible
- [ ] No routing inconsistencies

## 🚨 Risk Mitigation
- Backup current main.dart before changes
- Test changes incrementally
- Ensure Firebase configuration is correct
- Have rollback plan if issues arise
