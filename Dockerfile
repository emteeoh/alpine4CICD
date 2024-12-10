# Use the official Alpine Linux image as the base
FROM alpine:latest

ARG PRODUCT
ARG VERSION

# Update the package lists
RUN apk update

# Install gnupg
RUN apk add --update --virtual .deps --no-cache gnupg

# Install grep
RUN apk add --no-cache grep

# Install sha256sum
RUN apk add --no-cache sha256sum

# Install wget
RUN apk add --no-cache wget

# Install unzip
RUN apk add --no-cache unzip

# Download Terraform
RUN cd /tmp && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig

# validate checksum
RUN cd /tmp && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify ${PRODUCT}_${VERSION}_SHA256SUMS.sig ${PRODUCT}_${VERSION}_SHA256SUMS
    grep ${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS | sha256sum -c

# install terraform and cleanup
RUN cd /tmp && \
    unzip /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip -d /tmp && \
    mv /tmp/${PRODUCT} /usr/local/bin/${PRODUCT} && \
    rm -f /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS ${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig
