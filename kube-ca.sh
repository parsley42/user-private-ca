#!/bin/bash

# kube-ca.sh - convenience script for generating the kubernetes
# secret for the user CA.

if [ $# -ne 2 ]
then
    echo "Missing arguments '<ca-name>.crt' '<user>.p12'"
    exit 1
fi

CA_CERT="$1"
USER_NAME="$(basename -s p12 $2)"
USER_NAME="${USER_NAME%.}"
SECRET_NAME="${USER_NAME%.}-ca-cert"
KUBE_FILE="${SECRET_NAME}.yaml"

kubectl create secret generic $SECRET_NAME \
    --from-file=ca.crt=${CA_CERT} \
    --dry-run=client \
    -o yaml > $KUBE_FILE

echo "Created '$KUBE_FILE'"
