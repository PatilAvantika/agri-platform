#!/usr/bin/env python3
"""
Debug script to test the exact same request the Flutter app makes
"""

import requests
import json
import sys
import os

def test_exact_flutter_request():
    """Test the exact request that Flutter app makes"""
    print("🔍 Testing exact Flutter app request...")
    
    # This is the exact same data structure and URL the Flutter app uses
    url = "http://localhost:8000/api/chat/"
    
    body = {
        "user_id": "demo_user",
        "message": "Hello, can you help me with farming?",
        "language": "en"
    }
    
    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
    }
    
    print(f"URL: {url}")
    print(f"Body: {json.dumps(body, indent=2)}")
    print(f"Headers: {json.dumps(headers, indent=2)}")
    
    try:
        response = requests.post(
            url,
            json=body,
            headers=headers,
            timeout=30
        )
        
        print(f"\nResponse Status: {response.status_code}")
        print(f"Response Headers: {dict(response.headers)}")
        print(f"Response Body: {response.text}")
        
        if response.status_code == 200:
            try:
                data = response.json()
                reply = data.get("reply")
                if reply:
                    print(f"\n✅ SUCCESS! Reply received:")
                    print(f"'{reply}'")
                    return True
                else:
                    print("\n❌ ERROR: No 'reply' field in response")
                    print(f"Available fields: {list(data.keys())}")
            except json.JSONDecodeError:
                print("\n❌ ERROR: Invalid JSON response")
        else:
            print(f"\n❌ ERROR: HTTP {response.status_code}")
            
    except requests.exceptions.ConnectionError:
        print("\n❌ ERROR: Cannot connect to backend")
        print("Make sure backend is running:")
        print("cd backend && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000")
    except requests.exceptions.Timeout:
        print("\n❌ ERROR: Request timed out")
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
    
    return False

def test_flutter_urls():
    """Test different URLs that Flutter might try to connect to"""
    print("\n🌐 Testing different Flutter app URLs...")
    
    urls_to_test = [
        "http://localhost:8000/api/chat/",
        "http://10.0.2.2:8000/api/chat/",  # Android emulator
        "http://127.0.0.1:8000/api/chat/",  # Alternative localhost
    ]
    
    test_data = {
        "user_id": "demo_user",
        "message": "Hello",
        "language": "en"
    }
    
    for url in urls_to_test:
        print(f"\nTesting URL: {url}")
        try:
            response = requests.post(url, json=test_data, timeout=5)
            print(f"  Status: {response.status_code}")
            if response.status_code == 200:
                print(f"  ✅ SUCCESS!")
            else:
                print(f"  ❌ Failed with status {response.status_code}")
        except Exception as e:
            print(f"  ❌ Error: {e}")

if __name__ == "__main__":
    print("🔧 Agri Platform Chat Debug Tool")
    print("=" * 50)
    
    success = test_exact_flutter_request()
    
    if not success:
        test_flutter_urls()
    
    print("\n" + "=" * 50)
    if success:
        print("✅ Backend is working correctly!")
        print("If Flutter app still doesn't work, check:")
        print("1. Flutter app network permissions")
        print("2. Flutter app URL configuration")
        print("3. Console logs for detailed error messages")
    else:
        print("❌ Backend issue detected!")
        print("Please check backend logs and configuration")

