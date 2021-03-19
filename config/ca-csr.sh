CA_CSR=$(cat <<EOF
{
  "CN": "$CA_NAME",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "$CA_C",
      "L": "$CA_L",
      "O": "$CA_O",
      "OU": "$CA_OU",
      "ST": "$CA_ST"
    }
  ]
}
EOF
)
