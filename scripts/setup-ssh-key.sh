#!/bin/bash

KEY_NAME="devops-key"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

# Generate key if not exists
if [ ! -f "$KEY_PATH" ]; then
  echo "Generating SSH key..."
  ssh-keygen -t rsa -b 2048 -f "$KEY_PATH" -N ""
else
  echo "SSH key already exists at $KEY_PATH"
fi

# Upload key to AWS
echo "Uploading key to AWS..."
aws ec2 import-key-pair \
  --key-name "$KEY_NAME" \
  --public-key-material "fileb://${KEY_PATH}.pub" \
  --query 'KeyName' --output text

echo "SSH key setup completed"