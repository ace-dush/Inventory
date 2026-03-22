#!/usr/bin/env sh

set -eu

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required but was not found in PATH."
    echo "Install Docker Desktop or Docker Engine, then run this script again."
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose is required but not available via 'docker compose'."
    exit 1
fi

echo "Starting Part-DB with Docker Compose..."
docker compose up --build -d

echo "Waiting for Part-DB to answer on http://localhost:8080 ..."
attempt=0
until curl -fsS http://localhost:8080 >/dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge 60 ]; then
        echo "Part-DB did not become reachable in time."
        echo "Check logs with: docker compose logs --tail=200 partdb"
        exit 1
    fi
    sleep 2
done

echo "Part-DB is ready."
echo "URL: http://localhost:8080"
echo "Username: admin"
echo "Password: partdbadmin"