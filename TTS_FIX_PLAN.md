# TTS (Text-to-Speech) Fix Plan

## Current Issues Identified

### 1. Backend API URL Configuration
- **Issue**: TTS service is hardcoded to `http://192.168.0.105:8000`
- **Impact**: May not work if backend runs on different IP/port
- **Solution**: Make URL configurable based on environment

### 2. Dependencies Check
- **Issue**: Need to verify audioplayers dependency is properly installed
- **Impact**: Audio playback may fail
- **Solution**: Check and update pubspec.yaml

### 3. Error Handling
- **Issue**: TTS errors may not provide clear feedback to users
- **Impact**: Poor user experience when TTS fails
- **Solution**: Improve error handling and user feedback

## Fix Implementation Plan

### Step 1: Update TTS Service Configuration
- Make backend URL configurable
- Add environment-based URL detection
- Add fallback mechanisms

### Step 2: Fix Audio Player Issues
- Ensure proper audio player initialization
- Add audio permission handling
- Fix audio playback state management

### Step 3: Improve Error Handling
- Add proper exception handling for TTS failures
- Add user-friendly error messages
- Add retry mechanisms

### Step 4: Test and Verify
- Test TTS on different platforms
- Verify audio playback works correctly
- Ensure proper error states

## Files to Modify

1. `mobile_app/lib/services/tts_service.dart` - Update URL configuration
2. `mobile_app/lib/features/chatbot/chat_screen.dart` - Improve error handling
3. `mobile_app/pubspec.yaml` - Ensure dependencies are correct

## Testing Checklist

- [ ] TTS service connects to backend successfully
- [ ] Audio files are generated and played correctly
- [ ] Error states are handled gracefully
- [ ] TTS works on both Android and web platforms
- [ ] Volume controls and playback states work properly
