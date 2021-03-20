cat > config/client-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "${CLIENT_EXPIRE}h",
      "usages": [
        "client auth"
      ]
    },
    "profiles": {}
  }
}
EOF
