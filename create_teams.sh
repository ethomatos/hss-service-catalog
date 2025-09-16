#!/usr/bin/env bash
set -euo pipefail

: "${DD_SITE:?Please set DD_SITE}"
: "${DD_API_KEY:?Please set DD_API_KEY}"
: "${DD_APP_KEY:?Please set DD_APP_KEY}"

echo "Creating Datadog teams..."

# Create hss-server-team
echo "Creating hss-server-team..."
curl -s -X POST "https://api.${DD_SITE}/api/v2/teams" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "type": "team",
      "attributes": {
        "handle": "hss-server-team",
        "name": "HSS Server Team",
        "description": "Created for HSS demo - Server Team"
      }
    }
  }' | jq .

# Create hss-database-team
echo "Creating hss-database-team..."
curl -s -X POST "https://api.${DD_SITE}/api/v2/teams" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "type": "team",
      "attributes": {
        "handle": "hss-database-team",
        "name": "HSS Database Team",
        "description": "Created for HSS demo - Database Team"
      }
    }
  }' | jq .

# Create hss-security-team
echo "Creating hss-security-team..."
curl -s -X POST "https://api.${DD_SITE}/api/v2/teams" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "type": "team",
      "attributes": {
        "handle": "hss-security-team",
        "name": "HSS Security Team",
        "description": "Created for HSS demo - Security Team"
      }
    }
  }' | jq .

# Create hss-network-team
echo "Creating hss-network-team..."
curl -s -X POST "https://api.${DD_SITE}/api/v2/teams" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "type": "team",
      "attributes": {
        "handle": "hss-network-team",
        "name": "HSS Network Team",
        "description": "Created for HSS demo - Network Team"
      }
    }
  }' | jq .

echo "Team creation complete!"

