#!/usr/bin/env python3
"""
CORS proxy for SearXNG to enable Flutter web app access
This script adds CORS headers to SearXNG responses
"""

import sys
import os
import json
from pathlib import Path

# Add SearXNG to path
searxng_path = Path(__file__).parent / "searxng"
sys.path.insert(0, str(searxng_path))

# Import SearXNG modules
from searx import settings
from searx.webapp import app
from flask import request, jsonify, make_response
from flask_cors import CORS

def setup_cors():
    """Setup CORS for SearXNG Flask app"""
    CORS(app, origins=["http://localhost:*", "http://127.0.0.1:*", "*"], 
         methods=["GET", "POST", "OPTIONS"],
         allow_headers=["Content-Type", "Accept", "User-Agent"])
    
    @app.after_request
    def after_request(response):
        response.headers.add('Access-Control-Allow-Origin', '*')
        response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization,Accept,User-Agent')
        response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
        return response

    @app.route('/health', methods=['GET'])
    def health():
        """Health check endpoint"""
        return jsonify({"status": "ok", "service": "searxng-cors-proxy"})

    return app

if __name__ == '__main__':
    print("Starting SearXNG with CORS support...")
    print("SearXNG will be available at: http://localhost:8080")
    print("CORS enabled for Flutter frontend")
    
    # Setup CORS
    cors_app = setup_cors()
    
    # Run SearXNG with CORS
    cors_app.run(
        host='0.0.0.0',
        port=8080,
        debug=False,
        threaded=True
    )
