#!/bin/bash

set -e  # Exit on error

echo "🚀 Building containers..."
docker-compose build --no-cache

echo "📦 Starting containers..."
docker-compose up -d
