#!/usr/bin/env python3
"""
Test script to verify chat functionality is working correctly
"""

import requests
import json
import time
import sys
import os

# Add backend to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'backend'))

def test_backend_health():
    """Test if backend is running and healthy"""
    print("🔍 Testing backend health...")
    try:
        response = requests.get('http://localhost:8000/', timeout=5)
        print(f"✅ Backend health check: {response.status_code}")
        print(f"   Response: {response.json()}")
        return True
    except requests.exceptions.ConnectionError:
        print("❌ Backend is not running! Please start it with:")
        print("   cd backend && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000")
        return False
    except Exception as e:
        print(f"❌ Backend health check failed: {e}")
        return False

def test_chat_endpoint():
    """Test the chat endpoint directly"""
    print("\n💬 Testing chat endpoint...")
    
    test_messages = [
        "Hello, can you help me with farming?",
        "What crops should I plant in winter?",
        "Tell me about soil health"
    ]
    
    for i, message in enumerate(test_messages, 1):
        try:
            print(f"\n  Test {i}: '{message}'")
            
            chat_data = {
                "user_id": "test_user",
                "message": message,
                "language": "en"
            }
            
            response = requests.post(
                'http://localhost:8000/api/chat/',
                json=chat_data,
                timeout=10
            )
            
            if response.status_code == 200:
                chat_response = response.json()
                reply = chat_response.get('reply', 'No reply found')
                confidence = chat_response.get('confidence', 0)
                
                print(f"  ✅ Success! Status: {response.status_code}")
                print(f"     Reply: {reply[:100]}{'...' if len(reply) > 100 else ''}")
                print(f"     Confidence: {confidence}")
            else:
                print(f"  ❌ Failed! Status: {response.status_code}")
                print(f"     Response: {response.text}")
                
        except Exception as e:
            print(f"  ❌ Test failed: {e}")

def test_tts_endpoint():
    """Test the TTS endpoint"""
    print("\n🔊 Testing TTS endpoint...")
    
    try:
        tts_data = {
            "text": "Hello, this is a test of the text to speech system."
        }
        
        response = requests.post(
            'http://localhost:8000/api/tts/tts',
            json=tts_data,
            timeout=15
        )
        
        print(f"TTS Status: {response.status_code}")
        if response.status_code == 200:
            tts_response = response.json()
            file_path = tts_response.get('file_path', 'No file path found')
            print(f"✅ TTS Success! File path: {file_path}")
        else:
            print(f"❌ TTS Failed: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ TTS test failed: {e}")

def check_environment_variables():
    """Check required environment variables"""
    print("\n🔧 Checking environment variables...")
    
    # Try to load .env file
    env_path = os.path.join(os.path.dirname(__file__), 'backend', '.env')
    if os.path.exists(env_path):
        print(f"✅ Found .env file at: {env_path}")
        with open(env_path, 'r') as f:
            env_content = f.read()
            if 'ELEVENLABS_API_KEY' in env_content:
                print("✅ ELEVENLABS_API_KEY found in .env")
            else:
                print("⚠️  ELEVENLABS_API_KEY not found in .env")
    else:
        print(f"⚠️  No .env file found at: {env_path}")
        
        # Check environment variables
        elevenlabs_key = os.getenv('ELEVENLABS_API_KEY')
        if elevenlabs_key:
            print("✅ ELEVENLABS_API_KEY found in environment")
        else:
            print("⚠️  ELEVENLABS_API_KEY not found in environment")

def main():
    """Run all tests"""
    print("🚀 Agri Platform Chat Functionality Test")
    print("=" * 50)
    
    # Test backend health
    if not test_backend_health():
        print("\n❌ Cannot proceed - backend is not running!")
        sys.exit(1)
    
    # Check environment variables
    check_environment_variables()
    
    # Test chat functionality
    test_chat_endpoint()
    
    # Test TTS functionality
    test_tts_endpoint()
    
    print("\n" + "=" * 50)
    print("✅ Test completed!")
    print("\n📱 To test the mobile app:")
    print("1. Start backend: cd backend && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000")
    print("2. Start mobile app: cd mobile_app && flutter run -d chrome")
    print("3. Try sending a message in the chat")

if __name__ == "__main__":
    main()

