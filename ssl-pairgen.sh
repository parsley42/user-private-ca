#!/bin/bash -e

# ssl-pairgen.sh (a play on ssh-keygen)

# Defaults
CA_NAME="UserCA"
USER_NAME="user"
CP_O="Cluster Owners"
CP_OU="Cluster Administrators"
CLIENT_EXPIRE="8760" # hours in a year

if [ -e ".profile" ]
then
  . .profile
fi

CA_EXPIRE=$(( $CLIENT_EXPIRE + 1 ))

. config/ca-csr.sh        # Define CA_CSR
. config/client-csr.sh    # Define CLIENT_CSR
. config/client-config.sh # Create config/client-config.json

echo "Generating CA $CA_NAME"
echo "$CA_CSR" | cat

# Generate $CA_NAME-ca.crt and temporary CA key
echo "$CA_CSR" | cfssl gencert \
  -initca - | cfssljson -bare $CA_NAME
rm $CA_NAME.csr
mv $CA_NAME.pem $CA_NAME-ca.crt

# Generate $USER_NAME.p12
echo "$CLIENT_CSR" | cfssl gencert \
  -cn="$USER_NAME" \
  -ca="${CA_NAME}-ca.crt" \
  -ca-key="${CA_NAME}-key.pem" \
  -config=config/client-config.json - | cfssljson -bare $USER_NAME
rm ${USER_NAME}.csr

rm -f $CA_NAME-key.pem

openssl pkcs12 -export -out ${USER_NAME}.p12 \
  -inkey ${USER_NAME}-key.pem \
  -in ${USER_NAME}.pem \
  -certfile $CA_NAME-ca.crt

mv ${USER_NAME}.pem ${USER_NAME}.crt

echo "Created User CA pair '${CA_NAME}-ca.crt' and '${USER_NAME}.p12'; '${USER_NAME}.crt' informational."
