CA_CSR=$(cat <<EOF
{
  "CN": "$CA_NAME",
  "CA": {
    "expiry": "${CA_EXPIRE}h",
    "pathlen": 0
  },
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "$CP_O",
      "OU": "$CP_OU"
    }
  ]
}
EOF
)
