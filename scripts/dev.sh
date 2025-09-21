#!/bin/bash
set -e

echo "🚀 Starting Reckie development server..."
source .venv/bin/activate

if ! docker-compose -f docker/docker-compose.yml ps | grep -q "Up"; then
    echo "Starting Docker services..."
    docker-compose -f docker/docker-compose.yml up -d
fi

# Start server in background
echo "Starting FastAPI server..."
uvicorn app.main:app --reload --host 127.0.0.1 --port 8888 &
SERVER_PID=$!

# Wait for server to be ready
echo "Waiting for server to start..."
for i in {1..30}; do
    if curl -s http://127.0.0.1:8888/health > /dev/null 2>&1; then
        echo "✅ Server is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Server failed to start within 30 seconds"
        kill $SERVER_PID 2>/dev/null || true
        exit 1
    fi
    sleep 1
done

# Open browser
echo "🌐 Opening browser..."
if command -v open >/dev/null 2>&1; then
    # macOS
    open http://127.0.0.1:8888
elif command -v xdg-open >/dev/null 2>&1; then
    # Linux
    xdg-open http://127.0.0.1:8888
elif command -v start >/dev/null 2>&1; then
    # Windows
    start http://127.0.0.1:8888
else
    echo "Please open http://127.0.0.1:8888 in your browser"
fi

# Wait for server process
wait $SERVER_PID