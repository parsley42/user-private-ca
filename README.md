# User Private Certificate Authorities

The contents of this repository are for simplifying the creation of user private client certificates and certificate authorities, for use in a [Kubernetes](https://kubernetes.io) cluster.

## Rationale and Application

With the growth of Kubernetes, an interesting type of application has also grown in popularity - the Single User Pod. First seen in the [Gitpod](https://gitpod.io) online coding environment offering, and later in the [Eclipse Che](https://www.eclipse.org/che) "Kubernetes-Native IDE", this concept was later proposed for the University of Virginia ACCORD project to provide researchers with Single User Pods for code development and computational research applications. These pods have a unique URL specific to the individual user, and are accessible only by that user. To provide an extra factor of authentication for access to the pod ("something the user has" - a digital asset provided by the researcher), the concept of the User Private Certificate Authority was created.

Conceptually this operates in similar fashion to ssh key pairs, with the caveat that a User Private Certificate Authority can only grant a single user access to a single pod,(*) unlike `ssh` which typically grants several users access to a host.

## How it Works

As a proof-of-concept, these scripts wrap the `cfssl` tool suite to generate a temporary CA and a single passphrase-encypted client certificate, with relatively short expirations. The CA signing key is immediately discarded, leaving two artifacts:

### User CA
The `<user>-ca.crt` public CA certificate, typically loaded to the cluster in a project specific namespace, e.g. `my-project/username-ca-crt`. This CA cert is later referenced during creation of the user pod ingress definition, taking advantage of the Kubernetes [nginx-ingress](https://kubernetes.github.io/ingress-nginx/) standard [client certificate authentication](https://kubernetes.github.io/ingress-nginx/examples/auth/client-certs/) feature.

### User Client Certificate
The `<user>-<project>.p12` encrypted PKCS12 bundle actually includes two cryptography objects:
* The user's public certificate, signed by the temporary CA key and presented to the ingress controller to be validated by the user's CA cert
* The user's private key, used to prove the user has the private key corresponding to the signed public key

This bundle can be imported with it's passphrase by any modern browser, and the protocol allows the browser to easily identify the required certificate for authentication.

## Other Thoughts and Applications

### Short-Lived Use
Since the typical user workflow would be to create a certificate and immediately load it in to the desired browser(s), constraining the CA validity to a matter of months is less cumbersome to the user than similarly frequent required password changes.

### Trivial Revocation
Revoking the user's certificate is trivially and permanently done by deleting the user CA from the cluster.

### Private Developer Clusters
To simplify authentication and authorization to single-user clusters, this mechanism can be easily used to protect all cluster web applications.(**)

## Requirements

To use these scripts you'll need a Linux or MacOS host with `bash`, and [cfssl](https://cfssl.org/) installed somewhere in your `$PATH` (likely `/usr/local/bin`).

## Contents
In this repository:
* `config-defaults.json` and `csr-defaults.json`: outputs of `cfssl print-defaults ...` for ease of reference.

> (*) - Provided the user does not share their private client certificate and passphrase.

> (**) - This was (and is) the initial application for the author.
