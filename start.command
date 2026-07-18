#!/bin/bash
# Fretboard Hero launcher — double-click to start the game.
cd "$(dirname "$0")"

PORT=8000

# If the server is already running on this port, just open the game.
if lsof -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Server already running on port $PORT — opening the game."
  open "http://localhost:$PORT"
  exit 0
fi

echo "🎸 Starting Fretboard Hero at http://localhost:$PORT"
echo "   Leave this window open while you play. Press Ctrl+C to stop."

# Open the browser once the server is up.
( sleep 1; open "http://localhost:$PORT" ) &

python3 -m http.server $PORT
