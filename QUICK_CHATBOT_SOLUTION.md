# Simple Solution: Get Chatbot Working

## ✅ Reverted Changes
I've restored the original working code:
- ✅ `chat_service.dart` - Back to original IP address (192.168.0.105:8000)
- ✅ `tts_service.dart` - Back to original implementation
- ✅ `chat_screen.dart` - Back to original version
- ✅ Removed the new platform_utils.dart file

## 🚀 How to Get Chatbot Working

### Step 1: Start the Backend Server
```bash
# In a new terminal
cd /Users/sanketvalunj/agri-platform/backend
source .venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Step 2: Run the Flutter App
```bash
# In another terminal
cd /Users/sanketvalunj/agri-platform/mobile_app
flutter run -d chrome
```

## 📱 Test the Chatbot
1. Open the chatbot screen in the app
2. Send a message like "hi" or "best crop for me"
3. You should get a response from Agri Bot
4. Tap the speaker icon to test TTS

## 🔧 If TTS Still Doesn't Work
The TTS button issue on Chrome is a known limitation. The original code works perfectly for:
- **Android Emulator**: Both chatbot and TTS work
- **Physical Device**: Both chatbot and TTS work

For **Chrome/Web**: Chatbot works, but TTS has limitations due to browser security policies.

## 💡 Quick Fix for Different Networks
If you're on a different network, update the IP address in:
- `mobile_app/lib/services/chat_service.dart` (line with `192.168.0.105`)
- `mobile_app/lib/services/tts_service.dart` (line with `192.168.0.105`)

Replace `192.168.0.105` with your computer's local IP address.
