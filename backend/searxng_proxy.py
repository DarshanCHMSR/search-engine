#!/usr/bin/env python3
"""
Simple Flask backend to serve as a proxy for SearXNG API calls from Flutter
Handles CORS and provides a clean API interface
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import json
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# SearXNG configuration
SEARXNG_BASE_URL = os.environ.get('SEARXNG_URL', 'http://localhost:8080')
SEARXNG_SEARCH_ENDPOINT = '/search'

# Public SearXNG instances as fallback
PUBLIC_INSTANCES = [
    'https://search.sapti.me',
    'https://searx.be',
    'https://searx.info',
    'https://search.mdosch.de',
    'https://searx.tiekoetter.com',
]

def search_with_instance(instance_url, params):
    """Search using a specific SearXNG instance"""
    try:
        response = requests.get(
            f"{instance_url}{SEARXNG_SEARCH_ENDPOINT}",
            params=params,
            headers={
                'User-Agent': 'Golligog-Flutter-Backend/1.0',
                'Accept': 'application/json'
            },
            timeout=10
        )
        
        if response.status_code == 200:
            return response.json()
        else:
            return None
    except Exception as e:
        print(f"Error with instance {instance_url}: {e}")
        return None

@app.route('/api/search', methods=['GET'])
def search():
    """Search endpoint that proxies to SearXNG"""
    query = request.args.get('q', '').strip()
    if not query:
        return jsonify({'error': 'Query parameter "q" is required'}), 400
    
    # Search parameters
    params = {
        'q': query,
        'format': 'json',
        'category': request.args.get('category', 'general'),
        'lang': request.args.get('lang', 'en'),
        'pageno': request.args.get('page', '1'),
    }
    
    # Add engines parameter if specified
    engines = request.args.get('engines')
    if engines:
        params['engines'] = engines
    
    # Try local instance first
    result = search_with_instance(SEARXNG_BASE_URL, params)
    
    # If local instance fails, try public instances
    if not result:
        for instance in PUBLIC_INSTANCES:
            result = search_with_instance(instance, params)
            if result:
                break
    
    if result:
        return jsonify(result)
    else:
        return jsonify({
            'error': 'All search instances are unavailable. Please try again later.',
            'query': query,
            'number_of_results': 0,
            'results': []
        }), 503

@app.route('/api/engines', methods=['GET'])
def engines():
    """Get available engines from SearXNG"""
    try:
        response = requests.get(
            f"{SEARXNG_BASE_URL}/engines",
            headers={
                'User-Agent': 'Golligog-Flutter-Backend/1.0',
                'Accept': 'application/json'
            },
            timeout=5
        )
        
        if response.status_code == 200:
            return jsonify(response.json())
        else:
            return jsonify([])  # Return empty list if engines endpoint fails
    except Exception as e:
        print(f"Error getting engines: {e}")
        return jsonify([])

@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint"""
    # Check if local SearXNG instance is available
    local_healthy = False
    try:
        response = requests.get(f"{SEARXNG_BASE_URL}/healthz", timeout=3)
        local_healthy = response.status_code == 200
    except:
        pass
    
    # Check at least one public instance
    public_healthy = False
    for instance in PUBLIC_INSTANCES[:2]:  # Check first 2 instances
        try:
            response = requests.get(f"{instance}/", timeout=3)
            if response.status_code == 200:
                public_healthy = True
                break
        except:
            continue
    
    return jsonify({
        'status': 'healthy' if (local_healthy or public_healthy) else 'unhealthy',
        'local_instance': local_healthy,
        'public_instances_available': public_healthy,
        'searxng_url': SEARXNG_BASE_URL
    })

@app.route('/', methods=['GET'])
def index():
    """API information endpoint"""
    return jsonify({
        'name': 'Golligog SearXNG Backend',
        'version': '1.0.0',
        'description': 'Flask backend proxy for SearXNG search API',
        'endpoints': {
            '/api/search': 'Search endpoint (GET with ?q=query)',
            '/api/engines': 'Get available search engines',
            '/api/health': 'Health check'
        }
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('DEBUG', 'False').lower() == 'true'
    
    print(f"Starting Golligog SearXNG Backend on port {port}")
    print(f"SearXNG URL: {SEARXNG_BASE_URL}")
    print(f"Debug mode: {debug}")
    
    app.run(host='0.0.0.0', port=port, debug=debug)
