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
      "O": "$CP_O",
      "OU": "$CP_OU"
    }
  ]
}
EOF
)
