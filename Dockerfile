# Use the official Alpine Linux image as the base
FROM alpine:latest

# Update the package lists
RUN apk update

# Install Terraform
RUN apk add --no-cache terraform

# Set the working directory
WORKDIR /app

# Copy your Terraform configuration files
COPY . .
