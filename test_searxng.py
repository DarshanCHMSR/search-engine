#!/usr/bin/env python3
"""
Test script to access SearXNG API with proper headers to bypass bot detection
"""

import requests
import json

def test_searxng_api():
    """Test SearXNG API with headers that bypass bot detection"""
    
    # SearXNG URL
    url = "http://localhost:8080/search"
    
    # Headers that mimic a real browser and set the required proxy headers
    headers = {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'gzip, deflate',
        'Connection': 'keep-alive',
        'X-Forwarded-For': '127.0.0.1',
        'X-Real-IP': '127.0.0.1',
    }
    
    # Search parameters
    params = {
        'q': 'test search',
        'format': 'json',
        'language': 'en'
    }
    
    try:
        print("Testing SearXNG API...")
        response = requests.get(url, params=params, headers=headers, timeout=10)
        
        print(f"Status Code: {response.status_code}")
        print(f"Response Headers: {dict(response.headers)}")
        
        if response.status_code == 200:
            try:
                data = response.json()
                print(f"Success! Found {len(data.get('results', []))} results")
                
                # Print first few results
                for i, result in enumerate(data.get('results', [])[:3]):
                    print(f"\nResult {i+1}:")
                    print(f"  Title: {result.get('title', 'N/A')}")
                    print(f"  URL: {result.get('url', 'N/A')}")
                    print(f"  Content: {result.get('content', 'N/A')[:100]}...")
                    
                return True
            except json.JSONDecodeError:
                print("Response is not valid JSON:")
                print(response.text[:500])
                return False
        else:
            print(f"Error: {response.status_code}")
            print("Response content:")
            print(response.text[:500])
            return False
            
    except requests.RequestException as e:
        print(f"Request failed: {e}")
        return False

if __name__ == "__main__":
    test_searxng_api()
