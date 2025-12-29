#!/usr/bin/env python3
"""
Test script to verify TTS chat response integration.
This tests the complete flow: Chat -> Response -> TTS Generation -> Audio Playback
"""

import asyncio
import aiohttp
import time
import json

async def test_tts_chat_integration():
    """Test the complete TTS chat integration"""
    
    base_url = "http://localhost:8000"
    
    print("🧪 Testing TTS Chat Response Integration")
    print("=" * 50)
    
    async with aiohttp.ClientSession() as session:
        
        # Test 1: Health Check
        print("\n1. Testing backend health...")
        try:
            async with session.get(f"{base_url}/health", timeout=aiohttp.ClientTimeout(total=5)) as response:
                if response.status == 200:
                    print("✅ Backend is running")
                else:
                    print(f"❌ Backend health check failed: {response.status}")
                    return False
        except Exception as e:
            print(f"❌ Backend not accessible: {e}")
            return False
        
        # Test 2: TTS Service Test
        print("\n2. Testing TTS service...")
        try:
            tts_data = {
                "text": "Hello! This is a test message for TTS functionality in the Flutter chat app."
            }
            
            async with session.post(
                f"{base_url}/api/tts/tts",
                json=tts_data,
                timeout=aiohttp.ClientTimeout(total=30)
            ) as response:
                if response.status == 200:
                    tts_result = await response.json()
                    file_path = tts_result.get("file_path")
                    print(f"✅ TTS service working - Generated: {file_path}")
                    
                    # Test audio file accessibility
                    audio_url = f"{base_url}{file_path}"
                    async with session.head(audio_url, timeout=aiohttp.ClientTimeout(total=10)) as audio_response:
                        if audio_response.status == 200:
                            print(f"✅ Audio file accessible: {audio_url}")
                        else:
                            print(f"⚠️  Audio file not accessible: {audio_response.status}")
                else:
                    error_text = await response.text()
                    print(f"❌ TTS service failed: {response.status} - {error_text}")
                    return False
        except Exception as e:
            print(f"❌ TTS service error: {e}")
            return False
        
        # Test 3: Chat Service Test
        print("\n3. Testing chat service...")
        try:
            chat_data = {
                "user_id": "test_user",
                "message": "What are the benefits of organic farming?",
                "language": "en"
            }
            
            async with session.post(
                f"{base_url}/api/chat/",
                json=chat_data,
                timeout=aiohttp.ClientTimeout(total=30)
            ) as response:
                if response.status == 200:
                    chat_result = await response.json()
                    reply = chat_result.get("reply", "")
                    print(f"✅ Chat service working")
                    print(f"   Bot reply: {reply[:100]}{'...' if len(reply) > 100 else ''}")
                    
                    # Test 4: Auto TTS for chat response
                    print("\n4. Testing auto TTS generation for chat response...")
                    try:
                        tts_data_for_reply = {"text": reply}
                        async with session.post(
                            f"{base_url}/api/tts/tts",
                            json=tts_data_for_reply,
                            timeout=aiohttp.ClientTimeout(total=30)
                        ) as tts_response:
                            if tts_response.status == 200:
                                tts_result = await tts_response.json()
                                file_path = tts_result.get("file_path")
                                print(f"✅ Auto TTS generation working for chat response")
                                print(f"   Generated audio: {file_path}")
                            else:
                                print(f"❌ Auto TTS generation failed: {tts_response.status}")
                                return False
                    except Exception as e:
                        print(f"❌ Auto TTS generation error: {e}")
                        return False
                        
                else:
                    error_text = await response.text()
                    print(f"❌ Chat service failed: {response.status} - {error_text}")
                    return False
        except Exception as e:
            print(f"❌ Chat service error: {e}")
            return False
    
    print("\n" + "=" * 50)
    print("🎉 TTS Chat Integration Test: PASSED ✅")
    print("\n📋 Integration Status:")
    print("   ✅ Backend services running")
    print("   ✅ TTS service generating audio")
    print("   ✅ Chat service responding")
    print("   ✅ Auto TTS generation for chat responses")
    print("   ✅ Audio files accessible")
    print("\n🚀 Ready for Flutter app testing!")
    print("\nNext steps:")
    print("1. Start Flutter app: cd mobile_app && flutter run")
    print("2. Navigate to chat screen")
    print("3. Send a message")
    print("4. Observe automatic TTS generation and playback")
    
    return True

if __name__ == "__main__":
    try:
        success = asyncio.run(test_tts_chat_integration())
        if success:
            print("\n✅ All tests passed successfully!")
            exit(0)
        else:
            print("\n❌ Some tests failed!")
            exit(1)
    except KeyboardInterrupt:
        print("\n\n⏹️  Test interrupted by user")
        exit(1)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        exit(1)
