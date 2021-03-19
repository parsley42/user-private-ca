#!/bin/bash

# ssl-pairgen.sh (a play on ssh-keygen)

if [ ! -e ".profile" ]
then
    echo "Missing '.profile'"
    exit 1
fi

# Defaults
CA_NAME="UserCA"
CA_C="US"
USER_NAME="user"
CLIENT_EXPIRE="8760h"

. .profile

. config/ca-csr.sh     # Define CA_CSR
. config/ca-config.sh  # Create config/ca-config.json
. config/client-csr.sh # Define CLIENT_CSR

echo "Generating CA $CA_NAME"
echo "$CA_CSR" | cat

# Generate $CA_NAME-ca.crt and temporary CA key
echo "$CA_CSR" | cfssl gencert -initca - | cfssljson -bare $CA_NAME
rm $CA_NAME.csr
mv $CA_NAME.pem $CA_NAME-ca.crt

# Generate $USER_NAME.p12
echo "$CLIENT_CSR" | cfssl gencert \
  -cn="$USER_NAME" \
  -ca="${CA_NAME}-ca.crt" \
  -ca-key="${CA_NAME}-key.pem" \
  -config=config/ca-config.json \
  -profile=client - | cfssljson -bare $USER_NAME
rm ${USER_NAME}.csr

rm -f $CA_NAME-key.pem

openssl pkcs12 -export -out ${USER_NAME}.p12 \
  -inkey ${USER_NAME}-key.pem \
  -in ${USER_NAME}.pem \
  -certfile $CA_NAME-ca.crt

rm ${USER_NAME}-key.pem
rm ${USER_NAME}.pem

echo "Created User CA pair '${CA_NAME}-ca.crt' and '${USER_NAME}.p12'"
