cat > config/ca-config.json <<EOF 
{
  "signing": {
    "default": {
      "expiry": "168h"
    },
    "profiles": {
      "client": {
        "expiry": "$CLIENT_EXPIRE",
        "usages": [
          "client auth"
        ]
      }
    }
  }
}
EOF
