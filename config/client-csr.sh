CLIENT_CSR=$(cat <<EOF
{
  "hosts": [
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "$CLIENT_C",
      "L": "$CLIENT_L",
      "O": "$CLIENT_O",
      "OU": "$CLIENT_OU",
      "ST": "$CLIENT_ST"
    }
  ]
}
EOF
)
