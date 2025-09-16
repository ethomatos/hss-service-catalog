#!/usr/bin/env bash
set -euo pipefail

# Required environment variables
: "${DD_SITE:?Please set DD_SITE (e.g., datadoghq.com, us3.datadoghq.com)}"
: "${DD_API_KEY:?Please set DD_API_KEY}"
: "${DD_APP_KEY:?Please set DD_APP_KEY}"

DD_API_HOST="https://api.${DD_SITE}"
ENDPOINT="/api/v2/services/definitions"

echo "Uploading service definitions to Datadog Software Catalog..."
echo "API Host: ${DD_API_HOST}"
echo

# Function to convert YAML to JSON payload and upload
upload_service() {
    local yaml_file="$1"
    local service_name
    service_name=$(basename "$(dirname "$yaml_file")")
    
    echo "Processing: ${service_name} (${yaml_file})"
    
    # Convert YAML to JSON payload format expected by Datadog API
    local json_payload
    json_payload=$(cat <<EOF
{
  "data": [
    {
      "type": "service_definitions",
      "attributes": {
        "service_definition": $(yq eval -o=json "$yaml_file")
      }
    }
  ]
}
EOF
)
    
    # Upload to Datadog
    local response
    response=$(curl -s -X POST "${DD_API_HOST}${ENDPOINT}" \
        -H "DD-API-KEY: ${DD_API_KEY}" \
        -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
        -H "Content-Type: application/json" \
        -d "$json_payload")
    
    # Check if successful
    if echo "$response" | jq -e '.data[0].attributes.service_definition.metadata.name' >/dev/null 2>&1; then
        local created_name
        created_name=$(echo "$response" | jq -r '.data[0].attributes.service_definition.metadata.name')
        echo "✅ Successfully created: ${created_name}"
    else
        echo "❌ Failed to create ${service_name}"
        echo "Response: $response"
    fi
    echo
}

# Check if yq is available
if ! command -v yq >/dev/null 2>&1; then
    echo "Error: yq is required to convert YAML to JSON"
    echo "Install with: brew install yq"
    exit 1
fi

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required to parse JSON responses"
    echo "Install with: brew install jq"
    exit 1
fi

# Upload all service definitions
for yaml_file in services/*/service.datadog.yaml; do
    if [[ -f "$yaml_file" ]]; then
        upload_service "$yaml_file"
    fi
done

echo "Upload complete! Check your Datadog Software Catalog for the new services:"
echo "- hss-servers"
echo "- hss-databases" 
echo "- hss-networks"
echo "- hss-services"

